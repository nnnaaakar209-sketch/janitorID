# janitorID

> **Paket Pembersihan Data dengan Konversi Mata Uang & Analisis Kesehatan Data**

Data scientists, according to interviews and expert estimates, spend from 50 percent to 80 percent of their time mired in this more mundane labor of collecting and preparing unruly digital data, before it can be explored for useful nuggets.

– "For Big-Data Scientists, 'Janitor Work' Is Key Hurdle to Insight" (New York Times, 2014)

[![R-CMD-check](https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R](https://img.shields.io/badge/R-%3E%3D%204.0.0-blue.svg)](https://www.r-project.org/)

`janitorID` memiliki fungsi-fungsi sederhana untuk memeriksa dan membersihkan data kotor. Package ini dibangun dengan mempertimbangkan pengguna R pemula dan menengah serta dioptimalkan untuk kemudahan penggunaan. Pengguna R mahir sebenarnya sudah dapat melakukan banyak tugas ini, tetapi dengan `janitorID` mereka dapat melakukannya lebih cepat dan menghemat energi untuk hal-hal yang lebih menarik.

Fungsi utama `janitorID`:

- 💱 Mengkonversi mata uang secara real-time di 146 mata uang dunia;
- 🧹 Membersihkan data secara otomatis dengan pipeline komprehensif untuk nilai hilang, outlier, dan duplikat;
- 📊 Memvisualisasikan kesehatan data dengan dashboard interaktif, heatmap, dan sunburst chart;
- 📋 Menghasilkan laporan statistik dengan uji Chi-square, Cramer's V, dan Odds Ratio;
- ✅ Memvalidasi distribusi data kategorik dengan cross-validation.

`janitorID` adalah package yang berorientasi `tidyverse`. Secara spesifik, ia bekerja dengan baik dengan pipe `%>%` dan dioptimalkan untuk membersihkan data yang dibawa dengan package `readr` dan `readxl`.

---

## 📌 Apa yang Diwarisi dari Package `janitor` Asli?

Dari package `janitor` asli karya Sam Firke, `janitorID` mempertahankan:

| Fitur | Deskripsi |
|-------|-----------|
| **Alat Tabulasi** | `tabyl()` untuk membuat tabel frekuensi satu, dua, atau tiga variabel |
| **Filosofi Pembersihan Data** | Fungsi sederhana yang kompatibel dengan pipe |
| **Integrasi Tidyverse** | Kompatibilitas seamless dengan pipe `%>%` dan alur kerja `dplyr` |
| **Ramah Pengguna** | Dirancang untuk pengguna R pemula hingga menengah |

---

## 🆕 Apa yang Ditambahkan di `janitorID`?

`janitorID` memperluas package `janitor` asli dengan **lima kemampuan baru**:

| Fitur Baru | Deskripsi | Mengapa Penting |
|------------|-----------|-----------------|
| 💱 **Konversi Mata Uang Real-time** | Konversi nilai antar 146 mata uang dunia menggunakan kurs live dari API gratis | Memungkinkan analisis data keuangan dan internasional tanpa mencari kurs manual |
| 🧹 **Pipeline Pembersihan Data Otomatis** | `auto_analyze()`: Satu fungsi untuk profiling, pembersihan (missing, outlier, duplikat), dan pelaporan | Mengurangi pekerjaan persiapan data berulang dari berjam-jam menjadi hitungan detik |
| 📊 **Dashboard Kesehatan Data** | `plot_data_health()`: Visualisasi interaktif pola missing, outlier, korelasi, dan distribusi | Memberikan penilaian visual instan terhadap kualitas data |
| 📋 **Laporan Statistik Inferensial** | `tabyl_to_statistical_report_console()`: Hasilkan uji Chi-square, Cramer's V, dan Odds Ratio langsung dari tabel kontingensi | Menjembatani pembersihan data dengan analisis statistik |
| 🎨 **Visualisasi Profesional** | `ggheatmap_tabyl()` dan `plot_tabyl_sunburst_v2()`: Heatmap dan sunburst chart dari objek tabyl | Meningkatkan eksplorasi data dengan grafik siap publikasi |

---

## 🔧 Instalasi

Anda dapat menginstal versi pengembangan terbaru dari GitHub dengan:

``` r
# install.packages("remotes")
remotes::install_github("nnnaaakar209-sketch/janitorID")

