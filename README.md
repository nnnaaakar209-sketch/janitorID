# janitorID

> **Paket Pembersihan Data dengan Konversi Mata Uang & Analisis Kesehatan Data**

Ilmuwan data, menurut wawancara dan perkiraan para ahli, menghabiskan 50 hingga 80 persen waktu mereka untuk pekerjaan yang lebih "membosankan": mengumpulkan dan membersihkan data sebelum data tersebut siap untuk dieksplorasi.

– "For Big-Data Scientists, 'Janitor Work' Is Key Hurdle to Insight" (New York Times, 2014)

[![R-CMD-check](https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg)](https://www.r-project.org/)

---

## 📌 Apa itu janitorID?

`janitorID` adalah **ekstensi dan modifikasi** dari package `janitor` populer karya Sam Firke. Package ini mewarisi filosofi inti `janitor`—fungsi sederhana dan ramah pengguna untuk memeriksa dan membersihkan data kotor—namun menambahkan **kemampuan baru** untuk analisis mata uang dan penilaian kesehatan data otomatis.

### Apa yang Diwarisi dari Package `janitor` Asli?

Dari package `janitor` asli, `janitorID` mempertahankan:

| Fitur | Deskripsi |
|-------|-----------|
| **Alat Tabulasi** | `tabyl()` untuk membuat tabel frekuensi satu, dua, atau tiga variabel |
| **Filosofi Pembersihan Data** | Fungsi sederhana yang kompatibel dengan pipe |
| **Integrasi Tidyverse** | Kompatibilitas seamless dengan pipe `%>%` dan alur kerja `dplyr` |
| **Ramah Pengguna** | Dirancang untuk pengguna R pemula hingga menengah |

### Apa yang Ditambahkan/Dimodifikasi di `janitorID`?

`janitorID` memperluas package `janitor` asli dengan **lima kemampuan baru**:

| Fitur Baru | Deskripsi | Mengapa Penting |
|------------|-----------|-----------------|
| 💱 **Konversi Mata Uang Real-time** | Konversi nilai antar 146 mata uang dunia menggunakan kurs live dari API gratis | Memungkinkan analisis data keuangan dan internasional tanpa mencari kurs manual |
| 🧹 **Pipeline Pembersihan Data Otomatis** | `auto_analyze()`: Satu fungsi untuk profiling, pembersihan (missing, outlier, duplikat), dan pelaporan | Mengurangi pekerjaan persiapan data berulang dari berjam-jam menjadi hitungan detik |
| 📊 **Dashboard Kesehatan Data** | `plot_data_health()`: Visualisasi interaktif pola missing, outlier, korelasi, dan distribusi | Memberikan penilaian visual instan terhadap kualitas data |
| 📋 **Laporan Statistik Inferensial** | `tabyl_to_statistical_report_console()`: Hasilkan uji Chi-square, Cramer's V, dan Odds Ratio langsung dari tabel kontingensi | Menjembatani pembersihan data dengan analisis statistik |
| 🎨 **Visualisasi Profesional** | `ggheatmap_tabyl()` dan `plot_tabyl_sunburst_v2()`: Heatmap dan sunburst chart dari objek tabyl | Meningkatkan eksplorasi data dengan grafik siap publikasi |

### Mengapa Penambahan Ini Dilakukan?

| Penambahan | Alasan |
|------------|--------|
| **Konversi Mata Uang** | Banyak dataset dunia nyata melibatkan data keuangan antar negara. Tidak ada package R yang menggabungkan pembersihan data dengan konversi mata uang real-time. |
| **Pipeline Pembersihan Otomatis** | Pengguna sering melakukan langkah pembersihan yang sama berulang kali. Otomatisasi ini menghemat waktu dan mengurangi kesalahan. |
| **Dashboard Kesehatan Data** | Penilaian visual kualitas data lebih cepat dan intuitif daripada ringkasan numerik saja. |
| **Laporan Statistik** | Setelah membersihkan data, pengguna biasanya ingin menguji hipotesis. Integrasi inferensi statistik mengurangi perpindahan konteks. |
| **Visualisasi Profesional** | Komunikasi wawasan yang efektif membutuhkan grafik yang rapi. Fungsi ini membuatnya mudah. |

---

## 🔧 Instalasi

Anda dapat menginstal versi pengembangan dari GitHub:

```r
# install.packages("remotes")
remotes::install_github("nnnaaakar209-sketch/janitorID")
