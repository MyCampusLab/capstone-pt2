-- =========================================================================
-- VISIONSAFE: DEAD-MAN'S SWITCH (HEARTBEAT MONITOR)
-- =========================================================================

-- 0. Pastikan ekstensi pg_cron aktif
CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA extensions;

-- 1. Buat fungsi untuk memindai anak yang terputus (hilang kontak > 30 menit)
CREATE OR REPLACE FUNCTION check_dead_mans_switch()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Masukkan notifikasi peringatan untuk setiap anak yang mati
    -- (Catatan: Anda bisa memperluas ini untuk mengirim notifikasi ke orang tua menggunakan tabel family_groups jika ada)
    INSERT INTO public.notifications (user_id, title, content, type)
    SELECT 
        id, 
        'Perlindungan Terputus! 🚨', 
        'Aplikasi VisionSafe berhenti mengirim detak jantung (Heartbeat) selama lebih dari 30 menit. Pastikan aplikasi tidak dimatikan paksa oleh OS atau anak.',
        'alert'
    FROM public.profiles
    WHERE last_active_at < NOW() - INTERVAL '30 minutes'
      -- Mencegah spam: Jangan kirim notifikasi berulang jika notifikasi peringatan yang sama belum dibaca
      AND NOT EXISTS (
          SELECT 1 FROM public.notifications n 
          WHERE n.user_id = public.profiles.id 
            AND n.type = 'alert' 
            AND n.title = 'Perlindungan Terputus! 🚨'
            AND n.created_at > NOW() - INTERVAL '12 hours'
      );
END;
$$;

-- 2. Daftarkan jadwal Cron (Berjalan setiap 30 menit)
SELECT cron.schedule(
    'dead-mans-switch-monitor',    
    '*/30 * * * *',                
    $$ SELECT check_dead_mans_switch(); $$ 
);
