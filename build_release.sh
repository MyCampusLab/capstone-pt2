#!/bin/bash

# ==========================================
# VisionSafe - Release & Audit Automation
# ==========================================
# Skrip ini akan memastikan kode bersih (tanpa lints) 
# sebelum melakukan kompilasi production (AAB/APK).

echo "🚀 Memulai VisionSafe Pre-Flight Check..."

# 1. Bersihkan Cache (Mencegah build error karena sisa file lama)
echo "🧹 Membersihkan Flutter Cache..."
flutter clean
flutter pub get

# 2. Jalankan Code Audit (Analyze)
echo "🔍 Menjalankan Flutter Analyze (Audit Kode)..."
flutter analyze

if [ $? -ne 0 ]; then
    echo "❌ ERROR: Flutter Analyze menemukan masalah! Tolong perbaiki kode Flutter kamu sebelum lanjut build."
    exit 1
fi
echo "✅ Kode Flutter Bersih! Tidak ada lints."

# 3. Pilihan Build
echo "📦 Pilih target build:"
echo "1) Build APK (Untuk Testing Manual di HP)"
echo "2) Build AAB (Untuk Rilis Google Play Store)"
echo "3) Keluar"

read -p "Masukkan pilihan (1/2/3): " choice

case $choice in
    1)
        echo "⚙️ Membangun APK Release..."
        flutter build apk --release
        echo "🎉 Selesai! APK berada di: build/app/outputs/flutter-apk/app-release.apk"
        ;;
    2)
        echo "⚙️ Membangun App Bundle (AAB)..."
        flutter build appbundle --release
        echo "🎉 Selesai! AAB berada di: build/app/outputs/bundle/release/app-release.aab"
        ;;
    3)
        echo "Keluar."
        exit 0
        ;;
    *)
        echo "Pilihan tidak valid."
        exit 1
        ;;
esac
