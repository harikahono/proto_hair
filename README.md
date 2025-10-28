# Proto Hair - AR Hair Color Prototype

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

Prototipe aplikasi mobile yang dibangun menggunakan Flutter, memungkinkan pengguna untuk mencoba berbagai warna rambut secara virtual. Dengan slogan **"Try Before You Dye"**, aplikasi ini bertujuan memberikan gambaran visual sebelum pengguna memutuskan untuk mewarnai rambut.

## Fitur Utama (Prototipe)

* **Splash Screen:** Animasi pembuka saat aplikasi dimuat.
* **Autentikasi (UI):** Tampilan layar Login dan Registrasi (tanpa logika backend).
* **Home Screen:** Menu utama untuk navigasi ke fitur-fitur inti.
* **Mock AR Camera:**
    * Tampilan *mockup* kamera.
    * Seleksi warna rambut *real-time* (mengubah *overlay* warna pada gambar *mockup*).
    * Simulasi proses *capture* gambar.
* **Before & After:** Tampilan perbandingan gambar sebelum dan sesudah (simulasi) dengan *slider* interaktif.
* **Galeri:**
    * Menampilkan hasil *capture* (simulasi) dalam *grid*.
    * Melihat detail gambar dalam *modal view*.
    * Menghapus gambar dari galeri (state lokal).
* **Info Warna Rambut:** Halaman informatif statis mengenai berbagai jenis warna rambut, kecocokan dengan warna kulit, dan tips perawatan.
* **Navigasi Antar Halaman:** Alur pengguna yang jelas antar fitur.
* **Tema Gelap:** Desain UI konsisten dengan tema gelap dan aksen warna oranye.

## Teknologi yang Digunakan

* **Framework:** Flutter
* **Bahasa:** Dart
* **State Management:** `StatefulWidget` & `setState` (untuk state lokal sederhana)
* **Paket Utama:**
    * `lucide_flutter`: Untuk ikonografi.
    * `uuid`: Untuk generate ID unik gambar (simulasi).
    * `intl`: Untuk format tanggal di galeri.

## Cara Menjalankan Proyek

1.  **Prasyarat:**
    * Pastikan kamu sudah menginstal [Flutter SDK](https://flutter.dev/docs/get-started/install).
    * Pastikan kamu sudah menginstal [Git](https://git-scm.com/downloads).
    * Emulator Android/iOS atau perangkat fisik yang terhubung.

2.  **Clone Repository:**
    ```bash
    git clone [https://github.com/harikahono/proto_hair.git](https://github.com/harikahono/proto_hair.git)
    ```

3.  **Masuk ke Direktori Proyek:**
    ```bash
    cd proto_hair
    ```

4.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

5.  **Jalankan Aplikasi:**
    ```bash
    flutter run
    ```

## Catatan

* Ini adalah **prototipe** yang fokus pada **User Interface (UI)** dan **User Experience (UX)**.
* Fitur seperti pemrosesan gambar AR *real-time*, integrasi kamera sesungguhnya, penyimpanan data persisten (backend/database), dan fungsionalitas *sharing* belum diimplementasikan.
* Gambar yang digunakan di layar kamera dan galeri saat ini bersifat *mockup* (statis atau simulasi).

---

Dibuat oleh **[harikahono](https://github.com/harikahono)**
