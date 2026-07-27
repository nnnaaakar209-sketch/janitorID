<img src="man/figures/logo.png" width="80" align="left" style="margin-right: 10px; margin-top: -5px;">

# janitorID

**Paket Pembersihan Data dengan Konversi Mata Uang & Analisis Kesehatan Data**

<br>

Data scientists, according to interviews and expert estimates, spend from 50 percent to 80 percent of their time mired in this more mundane labor of collecting and preparing unruly digital data, before it can be explored for useful nuggets.

– "For Big-Data Scientists, 'Janitor Work' Is Key Hurdle to Insight" (New York Times, 2014)

[!(https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/nnnaaakar209-sketch/janitorID/actions/workflows/R-CMD-check.yaml)
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

```r
# install.packages("remotes")
remotes::install_github("nnnaaakar209-sketch/janitorID")
```

Setelah proses instalasi selesai, muat package dengan:

```r
library(janitorID)
```

---

## 🚀 Menggunakan `janitorID`

Dokumentasi lengkap setiap fungsi tersedia pada dokumentasi package. Berikut beberapa contoh penggunaan utama `janitorID`.

### 💱 1. Konversi Mata Uang *Real-time*

Fungsi `convert_currency()` digunakan untuk mengonversi nilai dari satu mata uang ke mata uang lain menggunakan kurs *real-time*. Package ini mendukung **146 mata uang** dari berbagai negara.

```r
library(janitorID)

# Konversi 100 USD ke Rupiah Indonesia
df <- data.frame(usd = 100)
convert_currency(df, "usd", "USD", "IDR")
#>   usd     usd_IDR
#> 1 100 Rp1,630,000

# Konversi USD ke Yen Jepang
df <- data.frame(usd = c(100, 200, 300))
convert_currency(df, "usd", "USD", "JPY")
#>   usd usd_JPY
#> 1 100 ¥14,800
#> 2 200 ¥29,600
#> 3 300 ¥44,400

# Konversi IDR ke SGD tanpa format mata uang
df_idr <- data.frame(idr = c(1000000, 2000000))
convert_currency(
  df_idr,
  "idr",
  "IDR",
  "SGD",
  format_output = FALSE
)
#>      idr  idr_SGD
#> 1 1000000 82.82209
#> 2 2000000 165.64417
```

---

### 🧹 2. Pipeline Pembersihan Data Otomatis

Fungsi `auto_analyze()` merupakan solusi **all-in-one** untuk analisis dan pembersihan data. Fungsi ini akan:

- membuat profil dataset,
- mendeteksi *missing values*,
- mendeteksi *outlier*,
- menghapus data duplikat,
- membersihkan data secara otomatis,
- menghasilkan laporan kesehatan data.

```r
library(janitorID)

# Analisis dan pembersihan dataset
result <- auto_analyze(mtcars)

# Melihat ringkasan hasil analisis
print(result)

# Mengakses data yang telah dibersihkan
data_bersih <- result$data_cleaned

# Melihat riwayat perubahan
result$changelog
```

Contoh ringkasan output:

```text
======================================================================
 AUTO ANALYZE - All-in-One Data Analysis
======================================================================

Dataset : mtcars
Dimensi : 32 baris × 11 kolom

✓ Data Profile selesai
✓ Data Insights selesai
✓ Cross Validation selesai
✓ Auto Cleaner selesai
✓ Health Dashboard selesai

Ringkasan:
• Missing values : 0
• Outlier dihapus : 2 baris
• Skor kesehatan data : 78/100 (BAIK)

======================================================================
```

---

### 📊 3. Dashboard Kesehatan Data

Fungsi `plot_data_health()` membuat dashboard interaktif untuk mengevaluasi kualitas dataset secara visual. Dashboard ini menampilkan:

- Pola *missing values*.
- Deteksi *outlier* pada setiap variabel.
- Heatmap korelasi antar variabel numerik.
- Distribusi data numerik dan kategorik.

```r
# Dashboard kesehatan data
plot_data_health(mtcars)

# Versi interaktif
plot_data_health(mtcars, interactive = TRUE)

# Dashboard dengan kustomisasi
plot_data_health(
  mtcars,
  title = "Dashboard Kesehatan Data Mobil",
  palette = "colorblind",
  show_outliers = TRUE,
  show_correlation = TRUE
)
```

---

### 📋 4. Laporan Statistik Inferensial

Fungsi `tabyl_to_statistical_report_console()` menghasilkan laporan statistik dari objek `tabyl`, termasuk uji **Chi-square**, **Cramer's V**, serta pemeriksaan asumsi secara otomatis.

```r
library(janitor)

# Membuat tabel kontingensi
tabel_mtcars <- tabyl(mtcars, cyl, gear)

# Laporan statistik interaktif
tabyl_to_statistical_report_console(tabel_mtcars)

# Laporan langsung tanpa menu interaktif
tabyl_to_statistical_report_simple(tabel_mtcars)

# Contoh tabel 2×2 (termasuk Odds Ratio)
tabel_2x2 <- tabyl(mtcars, vs, am)
tabyl_to_statistical_report_console(tabel_2x2)
```

---

### 🎨 5. Visualisasi Profesional

#### Heatmap dari Objek `tabyl`

```r
# Heatmap standar
ggheatmap_tabyl(tabel_mtcars)

# Menggunakan palet warna berbeda
ggheatmap_tabyl(
  tabel_mtcars,
  fill_palette = "Blues"
)

# Menyembunyikan nilai pada setiap sel
ggheatmap_tabyl(
  tabel_mtcars,
  show_values = FALSE
)
```

#### Sunburst Chart

```r
# Sunburst chart standar
plot_tabyl_sunburst_v2(tabel_mtcars)

# Sunburst chart dengan kustomisasi
plot_tabyl_sunburst_v2(
  tabel_mtcars,
  palette = "Set3",
  title = "Distribusi Cylinder vs Gear pada Mobil"
)
```

---

### 📈 6. Plot Kesehatan Data untuk Presentasi

Fungsi `plot_health_presentation()` menghasilkan visualisasi berukuran besar yang siap digunakan dalam presentasi maupun laporan.

```r
# Pola missing values
plot_health_presentation(
  airquality,
  type = "missing"
)

# Heatmap korelasi
plot_health_presentation(
  mtcars,
  type = "correlation"
)

# Deteksi outlier
plot_health_presentation(
  mtcars,
  type = "outlier"
)

# Distribusi numerik
plot_health_presentation(
  iris,
  type = "distribution"
)
```

---

## 📦 Daftar Fungsi

| Fungsi | Kategori | Deskripsi |
|---------|----------|-----------|
| `convert_currency()` | Mata Uang | Konversi antar 146 mata uang menggunakan kurs *real-time*. |
| `auto_analyze()` | Pembersihan Data | Analisis, pembersihan, dan pelaporan data otomatis. |
| `plot_data_health()` | Visualisasi | Dashboard interaktif kualitas data. |
| `plot_health_presentation()` | Visualisasi | Visualisasi kualitas data siap presentasi. |
| `ggheatmap_tabyl()` | Visualisasi | Heatmap dari objek `tabyl`. |
| `plot_tabyl_sunburst_v2()` | Visualisasi | Sunburst chart dari objek `tabyl`. |
| `tabyl_to_statistical_report_console()` | Statistik | Laporan statistik interaktif. |
| `tabyl_to_statistical_report_simple()` | Statistik | Laporan statistik tanpa menu interaktif. |
| `tabyl_save_report()` | Statistik | Menyimpan laporan statistik ke file. |

---

## 🌍 Mata Uang yang Didukung

`janitorID` mendukung **146 mata uang** yang berasal dari berbagai wilayah di dunia.

| Wilayah | Jumlah Negara | Contoh Mata Uang |
|---------|---------------:|------------------|
| Asia | 48 | IDR, MYR, SGD, THB, PHP, CNY, JPY, KRW, INR |
| Eropa | 44 | EUR, GBP, CHF, NOK, SEK, DKK, PLN |
| Afrika | 54 | ZAR, NGN, EGP, KES, MAD, XOF, XAF |
| Amerika | 35 | USD, CAD, MXN, BRL, ARS, CLP, COP |
| Oseania | 14 | AUD, NZD, FJD, PGK |

> **Total:** 146 mata uang dari 195 negara.

---

## 📁 Struktur Package

```text
janitorID/
├── R/
│   ├── currency_tools.R
│   ├── auto_analyze.R
│   ├── plot_data_health.R
│   ├── plot_health_presentation.R
│   ├── ggheatmap_tabyl.R
│   ├── plot_tabyl_sunburst.R
│   ├── tabyl_statistical_report.R
│   └── globals.R
├── man/
├── tests/
│   └── testthat/
│       ├── test-auto_analyze.R
│       ├── test-plot_data_health.R
│       ├── test-plot_health_presentation.R
│       └── test-currency_tools.R
├── DESCRIPTION
├── NAMESPACE
└── README.md
```

---

## 🧪 Menjalankan Test

`janitorID` telah dilengkapi dengan unit test untuk memastikan setiap fungsi bekerja sesuai yang diharapkan.

```r
# Menjalankan seluruh unit test
devtools::test()

# Menjalankan unit test untuk fungsi tertentu
devtools::test(filter = "auto_analyze")
```

---

## 👥 Tim Pengembang

Package **`janitorID`** dikembangkan oleh **Kelompok Data Science 1** sebagai bagian dari tugas akhir mata kuliah **Komputasi Statistika**.

| Nama | NIM | Peran |
|------|:---:|-------|
| Deska Asri Wulandari | 24611027 | Pengembang |
| Nur Rana Faizah | 24611029 | Pengembang |
| Karlina | 24611059 | Pengembang |

**Mata Kuliah:** Komputasi Statistika

**Semester:** 4

**Tahun Akademik:** 2025/2026

---

## 📄 Lisensi

Package ini didistribusikan di bawah **MIT License**.

`janitorID` merupakan pengembangan dari package **janitor** karya **Sam Firke**, yang juga menggunakan lisensi **MIT**.

---

## 🙏 Ucapan Terima Kasih

Kami mengucapkan terima kasih kepada:

- **Sam Firke**, atas pengembangan package **janitor** yang menjadi inspirasi dan fondasi bagi pengembangan `janitorID`.
- **Dosen Pengampu Mata Kuliah Komputasi Statistika**, atas bimbingan, arahan, dan masukan selama proses pengembangan package.
- **Seluruh anggota Kelompok Data Science 1**, atas kerja sama dan kontribusinya selama pengerjaan proyek.
- **Komunitas R**, atas berbagai package dan dokumentasi yang mendukung proses pengembangan.

---

## 📞 Kontak

Apabila menemukan bug, memiliki saran pengembangan, atau ingin berkontribusi pada package ini, silakan:

- Melaporkan *issue* melalui GitHub.
- Melakukan *fork* repository dan mengirimkan *Pull Request*.
- Memberikan masukan untuk pengembangan package di masa mendatang.

---

## ⭐ Dukung Kami

Apabila package **`janitorID`** bermanfaat bagi Anda, jangan lupa memberikan ⭐ pada repository GitHub.

Terima kasih telah menggunakan **`janitorID`**.

**Selamat Membersihkan & Menganalisis Data! 🧹📊🚀**

---

<p align="center">
<strong>Dikembangkan oleh Kelompok Data Science 1</strong><br>
Mata Kuliah <em>Komputasi Statistika</em><br>
Universitas Islam Indonesia • 2025/2026
</p>
