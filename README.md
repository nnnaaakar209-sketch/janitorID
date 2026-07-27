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


## 🚀 Menggunakan janitorID
Deskripsi lengkap setiap fungsi dapat ditemukan di dokumentasi package. Di bawah ini adalah contoh cepat bagaimana alat janitorID umumnya digunakan.

### 1. Konversi Mata Uang Real-time
Fungsi convert_currency() mengkonversi nilai mata uang dari satu mata uang ke mata uang lain menggunakan kurs real-time dari API gratis. Mendukung 146 mata uang dari seluruh dunia.

```r
library(janitorID)

# Konversi 100 USD ke IDR (Rupiah Indonesia)
df <- data.frame(usd = 100)
convert_currency(df, "usd", "USD", "IDR")
#>   usd     usd_IDR
#> 1 100 Rp1,630,000

# Konversi USD ke beberapa mata uang
df <- data.frame(usd = c(100, 200, 300))
convert_currency(df, "usd", "USD", "JPY")
#>   usd usd_JPY
#> 1 100 ¥14,800
#> 2 200 ¥29,600
#> 3 300 ¥44,400

# Konversi IDR ke SGD tanpa format mata uang
df_idr <- data.frame(idr = c(1000000, 2000000))
convert_currency(df_idr, "idr", "IDR", "SGD", format_output = FALSE)
#>      idr  idr_SGD
#> 1 1e+06 82.82209
#> 2 2e+06 165.64417

### 2. Pipeline Pembersihan Data Otomatis
Fungsi auto_analyze() adalah solusi all-in-one untuk analisis dan pembersihan data. Fungsi ini akan membuat profil data, mendeteksi masalah (missing, outlier, duplikat), membersihkannya, dan memberikan laporan komprehensif.

```r
library(janitorID)

# Analisis dan pembersihan otomatis dataset mtcars
result <- auto_analyze(mtcars)

# Lihat ringkasan laporan
print(result)
#> ======================================================================
#>  AUTO ANALYZE - All-in-One Data Analysis
#> ======================================================================
#>  Dataset: mtcars
#>  Dimensi: 32 baris x 11 kolom
#> ======================================================================
#> 
#>  [1/5] Membuat Data Profile...
#>  [2/5] Menghasilkan Data Insights...
#>  [3/5] Melakukan Cross Validation...
#>  [4/5] Menjalankan Auto Cleaner...
#>  [5/5] Membuat Health Dashboard...
#> 
#> ======================================================================
#>  AUTO ANALYZE SELESAI!
#> ======================================================================
#>  Ringkasan Akhir Pipeline:
#>     * Hasil Data: 30 baris x 11 kolom
#>     * Sisa Missing: 0 -> 0
#>     * Outlier Kolom: 2 kolom -> 0 kolom (2 baris dihapus)
#>     * Kolom: disp, hp
#>     * Skor Kesehatan Awal: 78 / 100 (BAIK)
#> ======================================================================

# Akses data yang sudah dibersihkan
data_bersih <- result$data_cleaned

# Akses riwayat perubahan
result$changelog

### 3. Dashboard Kesehatan Data
Fungsi plot_data_health() membuat dashboard interaktif yang memvisualisasikan:

Pola missing values

Deteksi outlier per kolom

Heatmap korelasi

Distribusi numerik dan kategorik

```r
# Buat dashboard kesehatan data mtcars
plot_data_health(mtcars)

# Versi interaktif dengan plotly
plot_data_health(mtcars, interactive = TRUE)

# Kustomisasi dashboard
plot_data_health(
  mtcars,
  title = "Dashboard Kesehatan Data Mobil",
  palette = "colorblind",
  show_outliers = TRUE,
  show_correlation = TRUE
)

### 4. Laporan Statistik Inferensial
Fungsi tabyl_to_statistical_report_console() menghasilkan laporan statistik komprehensif dari objek tabyl, termasuk uji Chi-square, ukuran efek Cramer's V, dan pengecekan asumsi.

```r
library(janitor)

# Buat tabel kontingensi
tabel_mtcars <- tabyl(mtcars, cyl, gear)
#>  cyl 3 4 5
#>    4 1 8 2
#>    6 2 4 1
#>    8 4 0 0

# Hasilkan laporan statistik interaktif
tabyl_to_statistical_report_console(tabel_mtcars)
# Pilih menu 1-4 untuk melihat berbagai bagian, 5 untuk keluar

# Laporan langsung (tanpa interaktif)
tabyl_to_statistical_report_simple(tabel_mtcars)

# Untuk tabel 2x2 (bonus Odds Ratio)
tabel_2x2 <- tabyl(mtcars, vs, am)
tabyl_to_statistical_report_console(tabel_2x2)
5. Visualisasi Profesional
Heatmap dari tabyl:

``` r
# Buat heatmap dari tabel kontingensi
ggheatmap_tabyl(tabel_mtcars)

# Dengan palet warna berbeda
ggheatmap_tabyl(tabel_mtcars, fill_palette = "Blues")

# Tanpa menampilkan nilai
ggheatmap_tabyl(tabel_mtcars, show_values = FALSE)
Sunburst Chart:

``` r
# Buat sunburst chart dari tabyl
plot_tabyl_sunburst_v2(tabel_mtcars)

# Dengan palet dan judul kustom
plot_tabyl_sunburst_v2(
  tabel_mtcars,
  palette = "Set3",
  title = "Distribusi Cylinder vs Gear pada Mobil"
)

### 6. Plot Kesehatan Data Siap Presentasi
Fungsi plot_health_presentation() membuat plot berukuran besar dan siap presentasi untuk metrik kesehatan tertentu.

```r
# Pola missing values
plot_health_presentation(airquality, type = "missing")

# Heatmap korelasi
plot_health_presentation(mtcars, type = "correlation")

# Deteksi outlier
plot_health_presentation(mtcars, type = "outlier")

# Distribusi numerik
plot_health_presentation(iris, type = "distribution")
📦 Daftar Fungsi Lengkap
Fungsi	Kategori	Deskripsi
convert_currency()	Mata Uang	Konversi antar 146 mata uang dengan kurs real-time
auto_analyze()	Pembersihan	Profiling, pembersihan, dan pelaporan data otomatis
plot_data_health()	Visualisasi	Dashboard interaktif kualitas data
plot_health_presentation()	Visualisasi	Plot kesehatan data siap presentasi
ggheatmap_tabyl()	Visualisasi	Heatmap dari objek tabyl
plot_tabyl_sunburst_v2()	Visualisasi	Sunburst chart dari objek tabyl
tabyl_to_statistical_report_console()	Statistik	Laporan uji Chi-square interaktif
tabyl_to_statistical_report_simple()	Statistik	Laporan statistik langsung
tabyl_save_report()	Statistik	Simpan laporan statistik ke file
📊 Mata Uang yang Didukung (146 Mata Uang)
janitorID mendukung 146 mata uang di 5 benua:

Wilayah	Negara	Kode Mata Uang
Asia	48	IDR, MYR, SGD, THB, PHP, BND, VND, LAK, MMK, KHR, USD, CNY, JPY, KRW, INR, ...
Eropa	44	EUR, GBP, CHF, RUB, NOK, SEK, DKK, PLN, HUF, CZK, ...
Afrika	54	ZAR, NGN, EGP, KES, GHS, MAD, TND, XOF, XAF, ...
Amerika	35	CAD, MXN, BRL, ARS, CLP, COP, PEN, ...
Oseania	14	AUD, NZD, FJD, PGK, ...
Total	195	146 mata uang unik

## 📁 Struktur Package
``` |
janitorID/
├── R/
│   ├── currency_tools.R           # convert_currency() + 146 mata uang
│   ├── auto_analyze.R             # auto_analyze() + helpers
│   ├── plot_data_health.R         # plot_data_health() dashboard
│   ├── plot_health_presentation.R # plot_health_presentation()
│   ├── ggheatmap_tabyl.R          # ggheatmap_tabyl() heatmap
│   ├── plot_tabyl_sunburst.R      # plot_tabyl_sunburst_v2()
│   ├── tabyl_statistical_report.R # Fungsi laporan statistik
│   └── globals.R                  # Deklarasi variabel global
├── man/                           # Dokumentasi (.Rd files)
├── tests/                         # Unit tests
│   └── testthat/
│       ├── test-auto_analyze.R
│       ├── test-plot_data_health.R
│       ├── test-plot_health_presentation.R
│       └── test-currency_tools.R
├── DESCRIPTION                    # Metadata package
├── NAMESPACE                      # Fungsi yang diekspor
└── README.md                      # File ini

## 🧪 Menjalankan Test
```r
# Jalankan semua test
devtools::test()

# Jalankan test spesifik
devtools::test(filter = "auto_analyze")
👥 Tim Pengembang
Kelompok Data Science 1 - UAS Komputasi Statistika

Nama	Peran
Deska Asri Wulandari - 24611027	Pengembang
Nur Rana Faizah - 24611029	Pengembang
Karlina - 24611059	Pengembang
Mata Kuliah: Komputasi Statistika

Semester: 4

Tahun Akademik: 2025/2026

📄 Lisensi
Package ini dilisensikan di bawah MIT License. Package janitor asli oleh Sam Firke (https://github.com/sfirke/janitor) juga dilisensikan di bawah MIT License.

🙏 Ucapan Terima Kasih
Sam Firke – Untuk package janitor yang luar biasa sebagai fondasi

Dosen Pengampu – Untuk bimbingan dan arahan selama UAS

Tim Data Science 1 – Untuk kolaborasi dan dukungan

Komunitas R – Untuk ekosistem yang mendukung pengembangan package R

📞 Kontak
Anda dipersilakan untuk:

mengirimkan saran dan melaporkan bug: https://github.com/nnnaaakar209-sketch/janitorID/issues

mem-fork repository dan mengirim pull request

⭐ Dukung Kami!
Jika package ini bermanfaat, berikan ⭐ di GitHub!

Selamat Membersihkan & Menganalisis Data! 🧹📊🚀

Dikembangkan oleh Kelompok Data Science 1 untuk UAS Komputasi Statistika
