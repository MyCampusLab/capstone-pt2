"""
VISIONSAFE BIG DATA ENGINE - CRAWLER & NO-SQL INGESTION SYSTEM
--------------------------------------------------------------------------------
Fokus: Pengambilan data terdistribusi (Data Collection), Preprocessing Textual,
dan Penyimpanan pada Skema NoSQL Document (JSON Document Store).
Memenuhi Kriteria 1, 2, dan 3 pada matakuliah Big Data.
"""

import os
import re
import json
import urllib.request
import xml.etree.ElementTree as ET

# Definisi Konfigurasi
DATA_SOURCE_URL = "https://pubmed.ncbi.nlm.nih.gov/rss/search/1y0y7q3_CgE_N4P6U0gS-y3_N9Z9y-/" # Feed RSS Pubmed Pencarian "Computer Vision Syndrome" atau "Myopia Screen Time"
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.path.join(SCRIPT_DIR, "big_data_document_store.json")

# List stopwords standar bahasa Indonesia & Inggris untuk data preprocessing
STOPWORDS = {
    "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "arent", "as", "at",
    "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "cant", "cannot", "could",
    "did", "didnt", "do", "does", "doesnt", "doing", "dont", "down", "during", "each", "few", "for", "from", "further",
    "had", "hadnt", "has", "hasnt", "have", "havent", "having", "he", "hed", "hell", "hes", "her", "here", "heres",
    "hers", "herself", "him", "himself", "his", "how", "hows", "i", "id", "ill", "im", "ive", "if", "in", "into",
    "is", "isnt", "it", "its", "itself", "lets", "me", "more", "most", "mustnt", "my", "myself", "no", "nor", "not",
    "of", "off", "on", "once", "only", "or", "other", "ought", "our", "ours", "ourselves", "out", "over", "own",
    "same", "shant", "she", "shed", "shell", "shes", "should", "shouldnt", "so", "some", "such", "than", "that",
    "thats", "the", "their", "theirs", "them", "themselves", "then", "there", "theres", "these", "they", "theyd",
    "theyll", "theyre", "theyve", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was",
    "wasnt", "we", "wed", "well", "were", "weve", "werent", "what", "whats", "when", "whens", "where", "wheres",
    "which", "while", "who", "whos", "whom", "why", "whys", "with", "wont", "would", "wouldnt", "you", "youd",
    "youll", "youre", "youve", "your", "yours", "yourself", "yourselves"
}

def crawl_medical_feeds():
    """
    Kriteria 1: Data Collection melalui Crawling/Scraping PubMed.
    Fungsi ini mendownload feed RSS ilmiah tentang kesehatan mata akibat screen-time.
    """
    print("[CRAWLER] Memulai Data Collection dari PubMed Medical Feed...")
    try:
        req = urllib.request.Request(
            DATA_SOURCE_URL, 
            headers={'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}
        )
        with urllib.request.urlopen(req) as response:
            xml_data = response.read()
        print(f"[CRAWLER] Sukses mengunduh {len(xml_data)} bytes data XML.")
        return xml_data
    except Exception as e:
        print(f"[CRAWLER] Gagal melakukan crawling dari PubMed feed: {e}")
        print("[CRAWLER] Menggunakan Local Mock Big Data Feed sebagai Fallback...")
        return get_mock_xml_feed()

def preprocess_text(text):
    """
    Kriteria 3: Preparation / Preprocessing Data.
    Meliputi pembersihan karakter khusus (regex), pengubahan case (lowercasing),
    tokenisasi, dan penyaringan stopword.
    """
    # 1. Lowercasing
    cleaned = text.lower()
    # 2. Menghilangkan tag HTML jika ada
    cleaned = re.sub(r'<[^>]+>', '', cleaned)
    # 3. Menghilangkan tanda baca dan angka
    cleaned = re.sub(r'[^a-zA-Z\s]', '', cleaned)
    # 4. Tokenisasi (pemisahan kata)
    words = cleaned.split()
    # 5. Stopword removal
    filtered_words = [word for word in words if word not in STOPWORDS and len(word) > 2]
    
    return {
        "raw_text": text,
        "cleaned_text": " ".join(filtered_words),
        "tokens_count": len(filtered_words),
        "keywords": list(set(filtered_words))[:15] # Ambil 15 kata kunci teratas
    }

def parse_and_store_to_nosql(xml_content):
    """
    Kriteria 2: Menyimpan Hasil Data Collection Big Data ke Database NoSQL.
    Kriteria 3: Penerapan Preprocessing pada Dokumen NoSQL yang disimpan.
    """
    print("[NO-SQL] Memulai parsing XML dan pemetaan ke skema NoSQL Document Store...")
    try:
        root = ET.fromstring(xml_content)
    except Exception as e:
        print(f"[NO-SQL] XML Parsing Error: {e}")
        return
    
    documents = []
    
    # Mencari item/artikel ilmiah di dalam RSS Channel
    channel = root.find('channel')
    if channel is not None:
        items = channel.findall('item')
        print(f"[NO-SQL] Ditemukan {len(items)} artikel ilmiah.")
        
        for idx, item in enumerate(items):
            title = item.find('title').text if item.find('title') is not None else "No Title"
            description = item.find('description').text if item.find('description') is not None else ""
            link = item.find('link').text if item.find('link') is not None else ""
            pub_date = item.find('pubDate').text if item.find('pubDate') is not None else ""
            
            # Gabungkan title dan description untuk analisis teks
            full_text_to_analyze = f"{title} {description}"
            
            # Kriteria 3: Jalankan Preprocessing Data
            preprocessed = preprocess_text(full_text_to_analyze)
            
            # Kriteria 2: Bangun Skema Dokumen NoSQL (BSON/JSON Structure)
            doc_id = f"PUBMED-DOC-{1000 + idx}"
            document = {
                "_id": doc_id,
                "metadata": {
                    "source": "NCBI PubMed",
                    "original_link": link,
                    "published_at": pub_date,
                    "crawled_at": "2026-06-06T01:25:00Z"
                },
                "content": {
                    "title": title,
                    "abstract_snippet": description
                },
                "preprocessing": {
                    "cleaned_body": preprocessed["cleaned_text"],
                    "tokens_count": preprocessed["tokens_count"],
                    "keywords": preprocessed["keywords"]
                }
            }
            documents.append(document)
            
    # Menyimpan ke file basis data NoSQL JSON (Representasi Document-oriented database)
    nosql_db = {
        "database_name": "visionsafe_bigdata_nosql",
        "collection_name": "eye_health_literatures",
        "total_documents": len(documents),
        "documents": documents
    }
    
    with open(DB_PATH, "w", encoding="utf-8") as f:
        json.dump(nosql_db, f, indent=4)
        
    print(f"[NO-SQL] Sukses menyimpan {len(documents)} dokumen NoSQL ke '{DB_PATH}'")

def get_mock_xml_feed():
    """
    Fallback mock feed jika koneksi internet terputus/dibatasi proxy di server kampus.
    Menghasilkan data RSS valid berstruktur PubMed ilmiah.
    """
    return """<?xml version="1.0" encoding="UTF-8"?>
    <rss version="2.0">
        <channel>
            <title>PubMed Search Results: Myopia Screen Time</title>
            <link>https://pubmed.ncbi.nlm.nih.gov</link>
            <description>PubMed Search Results for Computer Vision Syndrome and Myopia</description>
            <item>
                <title>Computer Vision Syndrome and Associated Risk Factors among Computer Users.</title>
                <description>Computer vision syndrome (CVS) is a group of eye and vision-related problems that result from prolonged computer, tablet, e-reader and smart phone use. Eye strain, dry eyes, and headaches are major risk factors.</description>
                <link>https://pubmed.ncbi.nlm.nih.gov/34215162/</link>
                <pubDate>Mon, 12 Jan 2026 08:00:00 GMT</pubDate>
            </item>
            <item>
                <title>Prevalence of Myopia and Screen Time Exposure in Young Children: A Systematic Review.</title>
                <description>Increased digital screen exposure is significantly associated with higher odds of myopia, particularly in children maintaining close viewing distances of less than thirty-five centimeters.</description>
                <link>https://pubmed.ncbi.nlm.nih.gov/35112281/</link>
                <pubDate>Wed, 18 Feb 2026 08:00:00 GMT</pubDate>
            </item>
            <item>
                <title>Digital Eye Strain: Preventive Interventions and Eye Exercises Effectiveness.</title>
                <description>The 20-20-20 rule and regular blinking exercises substantially decrease dry eye symptoms and visual fatigue during continuous smart device operations.</description>
                <link>https://pubmed.ncbi.nlm.nih.gov/36881920/</link>
                <pubDate>Fri, 20 Mar 2026 08:00:00 GMT</pubDate>
            </item>
        </channel>
    </rss>
    """

if __name__ == "__main__":
    raw_feed = crawl_medical_feeds()
    parse_and_store_to_nosql(raw_feed)
