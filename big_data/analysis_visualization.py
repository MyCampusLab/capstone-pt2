"""
VISIONSAFE BIG DATA ENGINE - ANALYTICS & VISUALIZATION SYSTEM
--------------------------------------------------------------------------------
Fokus: Analisis statistik textual (Word Frequency) dari NoSQL Document Store
dan pembuatan visualisasi grafik (Bar Chart) menggunakan matplotlib.
Memenuhi Kriteria 4 pada matakuliah Big Data.
"""

import os
import json
import collections

# Path konfigurasi
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(SCRIPT_DIR, "big_data_document_store.json")
OUTPUT_IMAGE_PATH = os.path.join(SCRIPT_DIR, "eye_health_analytics.png")

def analyze_and_visualize():
    print("[ANALYTICS] Memulai analisis data text mining dari NoSQL Document Store...")
    
    # Check keberadaan database NoSQL JSON
    # Jika tidak ditemukan di folder big_data, coba cari di root folder
    nosql_path = DB_PATH
    if not os.path.exists(nosql_path):
        root_db_path = os.path.join(os.path.dirname(SCRIPT_DIR), "big_data_document_store.json")
        if os.path.exists(root_db_path):
            nosql_path = root_db_path
        else:
            print(f"[ANALYTICS] Database NoSQL tidak ditemukan di {nosql_path} atau root. Harap jalankan crawler.py terlebih dahulu.")
            return

    try:
        with open(nosql_path, "r", encoding="utf-8") as f:
            nosql_db = json.load(f)
    except Exception as e:
        print(f"[ANALYTICS] Gagal membaca basis data NoSQL: {e}")
        return

    documents = nosql_db.get("documents", [])
    if not documents:
        print("[ANALYTICS] Tidak ada dokumen yang bisa dianalisis di dalam NoSQL store.")
        return

    print(f"[ANALYTICS] Memproses {len(documents)} dokumen literatur...")

    # Gabungkan semua kata hasil preprocessing dari seluruh dokumen
    all_words = []
    for doc in documents:
        cleaned_body = doc.get("preprocessing", {}).get("cleaned_body", "")
        all_words.extend(cleaned_body.split())

    # Lakukan perhitungan frekuensi kata kunci (Word Counter)
    word_counts = collections.Counter(all_words)
    common_words = word_counts.most_common(10) # 10 kata terpopuler

    print("[ANALYTICS] Frekuensi Kata Terpopuler Hasil Crawling PubMed:")
    for word, count in common_words:
        print(f"  - '{word}': {count} kali")

    # Membuat visualisasi data menggunakan matplotlib secara otonom
    try:
        import matplotlib
        matplotlib.use('Agg') # Non-interactive backend agar bisa jalan di headless environment
        import matplotlib.pyplot as plt
        
        # Pisahkan kata dan nilainya
        words = [w[0].upper() for w in common_words]
        counts = [w[1] for w in common_words]

        # Konfigurasi gaya visualisasi (Aesthetic Dark/Modern Theme)
        plt.figure(figsize=(10, 6), facecolor="#121212")
        ax = plt.axes()
        ax.set_facecolor("#1e1e1e")
        
        # Visualisasi diagram batang horizontal (Horizontal Bar Chart)
        bars = ax.barh(words, counts, color="#00E676", height=0.6, edgecolor="none")
        
        # Tambahkan nilai di ujung batang
        for bar in bars:
            width = bar.get_width()
            ax.text(width + 0.1, bar.get_y() + bar.get_height()/2, f'{int(width)}', 
                    va='center', ha='left', color='#FFFFFF', fontweight='bold', fontsize=10)

        # Styling label & judul
        ax.spines['bottom'].set_color('#333333')
        ax.spines['left'].set_color('#333333')
        ax.spines['top'].set_visible(False)
        ax.spines['right'].set_visible(False)
        
        ax.tick_params(colors='#B0BEC5', which='both')
        plt.title("ANALISIS FREKUENSI KATA KUNCI MEDIS (CVS & MYOPIA)\nSumber Data: NCBI PubMed (Big Data Feed Scraper)", 
                  color="#FFFFFF", fontsize=12, fontweight='bold', pad=20)
        plt.xlabel("Frekuensi Kemunculan Kata", color="#B0BEC5", labelpad=10)
        plt.ylabel("Kata Kunci Terpilih", color="#B0BEC5", labelpad=10)
        
        plt.tight_layout()
        plt.savefig(OUTPUT_IMAGE_PATH, dpi=150, facecolor="#121212")
        plt.close()
        
        print(f"[ANALYTICS] Visualisasi grafik berhasil dibuat dan disimpan di: {OUTPUT_IMAGE_PATH}")
        
    except ImportError:
        print("[ANALYTICS] Modul matplotlib tidak terinstall. Membuat visualisasi dalam format ASCII Table sebagai alternatif:")
        print("+" + "-"*20 + "+" + "-"*10 + "+")
        print("| KATA KUNCI         | FREKUENSI|")
        print("+" + "-"*20 + "+" + "-"*10 + "+")
        for word, count in common_words:
            print(f"| {word.upper():<18} | {count:<8} |")
        print("+" + "-"*20 + "+" + "-"*10 + "+")
        print("[ANALYTICS] Install matplotlib menggunakan 'pip install matplotlib' untuk mendapatkan diagram PNG profesional.")

if __name__ == "__main__":
    analyze_and_visualize()
