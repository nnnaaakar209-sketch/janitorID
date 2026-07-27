# ============================================================================
# R/globals.R
# Mendeklarasikan global variables untuk menghindari NOTE di check()
# ============================================================================

utils::globalVariables(c(
  # ==========================================================================
  # Untuk plot_data_health
  # ==========================================================================
  "column",        # Nama kolom
  "row_id",        # ID baris
  "is_missing",    # Status missing
  "pct_outliers",  # Persentase outlier
  "Var1",          # Variabel 1 untuk korelasi
  "Var2",          # Variabel 2 untuk korelasi
  "Correlation",   # Nilai korelasi
  "value",         # Nilai umum
  "pct",           # Persentase
  "Metrik",        # Nama metrik
  "Nilai",         # Nilai metrik
  ".",             # Placeholder untuk piping

  # ==========================================================================
  # Untuk auto_analyze
  # ==========================================================================
  "step",          # Langkah ke-
  "timestamp",     # Waktu
  "action",        # Aksi yang dilakukan
  "rows_before",   # Jumlah baris sebelum
  "rows_after",    # Jumlah baris setelah
  "cols_before",   # Jumlah kolom sebelum
  "cols_after",    # Jumlah kolom setelah
  "missing_before",# Missing sebelum
  "missing_after", # Missing setelah
  "details",       # Detail tambahan
  "n",             # Jumlah/frekuensi
  "total_row",     # Total per baris
  "proportion",    # Proporsi
  "percent",       # Persentase
  "anomaly",       # Status anomali
  "anomaly_type"   # Tipe anomali

  # ==========================================================================
  # TAMBAHKAN VARIABEL LAIN JIKA DIPERLUKAN
  # ==========================================================================
  # Contoh tambahan untuk fungsi lain:

  # Untuk convert_currency
  # "currency_code", "exchange_rate", "from_currency", "to_currency",

  # Untuk ggheatmap_tabyl
  # "Variabel_Kolom", "Nilai",

  # Untuk plot_tabyl_sunburst_v2
  # "var_luar", "Total_Dalam", "pos_y",
))

# ============================================================================
# END OF GLOBALS.R
# ============================================================================
