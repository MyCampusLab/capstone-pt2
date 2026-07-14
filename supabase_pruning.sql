-- =========================================================================
-- VISIONSAFE: BIG DATA EFFICIENCY & PRUNING SCRIPT
-- Eksekusi skrip ini di SQL Editor Supabase Anda untuk mencegah tagihan
-- membengkak dan memastikan database tetap ringan.
-- =========================================================================

-- 1. Pastikan ekstensi pg_cron aktif (Supabase mendukung ini secara native)
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- 2. Buat Fungsi Pembersih (Pruning Function)
-- Fungsi ini akan menghapus log telemetri yang AMAN (is_violation = false) 
-- dan sudah berusia lebih dari 30 hari. Log pelanggaran tetap dipertahankan 
-- secara permanen untuk keperluan histori kesehatan.
CREATE OR REPLACE FUNCTION prune_old_telemetry()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    -- Menghapus log telemetri (Heartbeat aman) yang usianya lebih dari 30 hari
    DELETE FROM telemetry_logs
    WHERE is_violation = false 
    AND created_at < NOW() - INTERVAL '30 days';
    
    -- Catatan Opsional: Jika ingin menghapus semua log (termasuk pelanggaran) 
    -- yang usianya di atas 1 tahun (365 hari):
    -- DELETE FROM telemetry_logs WHERE created_at < NOW() - INTERVAL '365 days';
END;
$$;

-- 3. Daftarkan jadwal Cron (Berjalan otomatis setiap jam 02:00 Pagi)
-- Jadwal menggunakan format Cron: Menit Jam Hari Bulan HariDalamSeminggu
SELECT cron.schedule(
    'prune-telemetry-nightly',    -- Nama cron job
    '0 2 * * *',                  -- Berjalan setiap pukul 02:00 AM
    $$ SELECT prune_old_telemetry(); $$ -- Perintah yang dieksekusi
);

-- =========================================================================
-- INFO: Jika Anda ingin membatalkan (unschedule) job di kemudian hari, 
-- gunakan perintah berikut:
-- SELECT cron.unschedule('prune-telemetry-nightly');
-- =========================================================================
