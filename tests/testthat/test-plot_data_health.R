# ============================================================================
# tests/testthat/test-plot_data_health.R
# Unit Test untuk fungsi plot_data_health()
# ============================================================================

# ----------------------------------------------------------------------------
# TEST 1: Validasi Input
# ----------------------------------------------------------------------------

test_that("plot_data_health() memvalidasi input", {
  # Input harus data frame
  expect_error(
    plot_data_health(list()),
    "Parameter 'data' harus berupa data frame."
  )

  expect_error(
    plot_data_health(c(1, 2, 3)),
    "Parameter 'data' harus berupa data frame."
  )

  # Data frame kosong
  df_empty <- data.frame()
  expect_silent(plot_data_health(df_empty, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 2: Bekerja dengan dataset standar
# ----------------------------------------------------------------------------

test_that("plot_data_health() bekerja dengan dataset standar", {
  data("iris")
  expect_silent(plot_data_health(iris, interactive = FALSE))

  data("airquality")
  expect_silent(plot_data_health(airquality, interactive = FALSE))

  data("mtcars")
  expect_silent(plot_data_health(mtcars, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 3: Menangani tipe data campuran
# ----------------------------------------------------------------------------

test_that("plot_data_health() menangani tipe data campuran", {
  df <- data.frame(
    a = 1:5,
    b = letters[1:5],
    c = factor(c("X", "Y", "X", "Y", "X")),
    d = c(TRUE, FALSE, TRUE, FALSE, TRUE),
    stringsAsFactors = FALSE
  )
  expect_silent(plot_data_health(df, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 4: Menangani edge cases
# ----------------------------------------------------------------------------

test_that("plot_data_health() menangani edge cases", {
  # Data dengan 1 baris
  df_satu <- data.frame(x = 1, y = "A")
  expect_silent(plot_data_health(df_satu, interactive = FALSE))

  # Data dengan 1 kolom
  df_satu_kolom <- data.frame(x = 1:10)
  expect_silent(plot_data_health(df_satu_kolom, interactive = FALSE))

  # Data dengan semua nilai NA
  df_na <- data.frame(
    x = c(NA, NA, NA),
    y = c(NA, NA, NA)
  )
  expect_silent(plot_data_health(df_na, interactive = FALSE))

  # Data dengan 0 baris
  df_kosong <- data.frame(x = integer(), y = character())
  expect_silent(plot_data_health(df_kosong, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 5: Menerima berbagai parameter
# ----------------------------------------------------------------------------

test_that("plot_data_health() menerima berbagai parameter", {
  data("iris")

  # Tanpa outlier
  expect_silent(plot_data_health(
    iris,
    show_outliers = FALSE,
    interactive = FALSE
  ))

  # Tanpa korelasi
  expect_silent(plot_data_health(
    iris,
    show_correlation = FALSE,
    interactive = FALSE
  ))

  # Tanpa missing
  expect_silent(plot_data_health(
    iris,
    show_missing = FALSE,
    interactive = FALSE
  ))

  # Tanpa distribusi
  expect_silent(plot_data_health(
    iris,
    show_distribution = FALSE,
    interactive = FALSE
  ))

  # Tanpa summary
  expect_silent(plot_data_health(
    iris,
    show_summary = FALSE,
    interactive = FALSE
  ))

  # Dengan judul custom
  expect_silent(plot_data_health(
    iris,
    title = "Custom Title",
    interactive = FALSE
  ))

  # Dengan palette colorblind
  expect_silent(plot_data_health(
    iris,
    palette = "colorblind",
    interactive = FALSE
  ))

  # Dengan palette vibrant
  expect_silent(plot_data_health(
    iris,
    palette = "vibrant",
    interactive = FALSE
  ))

  # Dengan is_cleaned = TRUE
  expect_silent(plot_data_health(
    iris,
    is_cleaned = TRUE,
    interactive = FALSE
  ))
})

# ----------------------------------------------------------------------------
# TEST 6: Menangani max_cols
# ----------------------------------------------------------------------------

test_that("plot_data_health() menangani max_cols", {
  # Buat data dengan 20 kolom
  df_banyak <- as.data.frame(matrix(rnorm(400), nrow = 20, ncol = 20))
  names(df_banyak) <- paste0("col_", 1:20)

  # Harusnya ada warning
  expect_warning(
    plot_data_health(df_banyak, interactive = FALSE),
    "Data memiliki 20 kolom. Hanya 15 kolom pertama yang akan ditampilkan."
  )

  # Dengan max_cols yang lebih besar
  expect_silent(plot_data_health(
    df_banyak,
    max_cols = 25,
    interactive = FALSE
  ))
})

# ----------------------------------------------------------------------------
# TEST 7: Mengembalikan objek ggplot
# ----------------------------------------------------------------------------

test_that("plot_data_health() mengembalikan objek ggplot atau patchwork", {
  data("iris")

  p <- plot_data_health(iris, interactive = FALSE)

  # Harusnya ggplot, patchwork, atau grid
  expect_true(
    inherits(p, "ggplot") ||
      inherits(p, "patchwork") ||
      inherits(p, "gtable") ||
      inherits(p, "gg")
  )
})

# ----------------------------------------------------------------------------
# TEST 8: Data dengan banyak missing values
# ----------------------------------------------------------------------------

test_that("plot_data_health() menangani data dengan banyak missing", {
  df_missing <- data.frame(
    x = c(1, NA, 3, NA, 5),
    y = c(NA, 2, NA, 4, NA),
    z = c(1, 2, 3, 4, 5)
  )

  expect_silent(plot_data_health(df_missing, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 9: Data dengan outlier
# ----------------------------------------------------------------------------

test_that("plot_data_health() mendeteksi outlier", {
  # Buat data dengan outlier
  set.seed(123)
  df_outlier <- data.frame(
    normal = rnorm(50, mean = 0, sd = 1),
    outlier = c(rnorm(48, mean = 0, sd = 1), 100, -100)
  )

  p <- plot_data_health(df_outlier, interactive = FALSE)

  # Harusnya berjalan tanpa error
  expect_silent(plot_data_health(df_outlier, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 10: Data dengan korelasi tinggi
# ----------------------------------------------------------------------------

test_that("plot_data_health() menangani korelasi tinggi", {
  # Buat data dengan korelasi sempurna
  set.seed(123)
  x <- rnorm(50)
  df_cor <- data.frame(
    a = x,
    b = x + rnorm(50, 0, 0.1),  # korelasi tinggi
    c = -x + rnorm(50, 0, 0.1)  # korelasi negatif
  )

  expect_silent(plot_data_health(df_cor, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 11: Semua parameter di-off
# ----------------------------------------------------------------------------

test_that("plot_data_health() dengan semua parameter FALSE", {
  data("iris")

  p <- plot_data_health(
    iris,
    show_outliers = FALSE,
    show_correlation = FALSE,
    show_missing = FALSE,
    show_distribution = FALSE,
    show_summary = FALSE,
    interactive = FALSE
  )

  # Harusnya tetap return sesuatu (pesan "Tidak ada plot yang dipilih")
  expect_true(inherits(p, "ggplot"))
})

# ----------------------------------------------------------------------------
# TEST 12: Interactive mode (skip jika plotly tidak tersedia)
# ----------------------------------------------------------------------------

test_that("plot_data_health() interactive mode berjalan", {
  skip_if_not_installed("plotly")

  data("iris")

  # Harusnya berjalan tanpa error (tapi mungkin return plotly)
  expect_silent(plot_data_health(iris, interactive = TRUE))
})

# ----------------------------------------------------------------------------
# TEST 13: Data dengan nama kolom yang aneh
# ----------------------------------------------------------------------------

test_that("plot_data_health() menangani nama kolom aneh", {
  df_aneh <- data.frame(
    "Kolom 1" = 1:5,
    "Kolom-2" = letters[1:5],
    "Kolom_3" = c(TRUE, FALSE, TRUE, FALSE, TRUE),
    check.names = FALSE
  )

  expect_silent(plot_data_health(df_aneh, interactive = FALSE))
})

# ----------------------------------------------------------------------------
# TEST 14: Semua tipe data dalam satu data frame
# ----------------------------------------------------------------------------

test_that("plot_data_health() menangani semua tipe data", {
  df_all_types <- data.frame(
    numeric = 1:10,
    integer = as.integer(1:10),
    character = letters[1:10],
    factor = factor(rep(c("A", "B"), 5)),
    logical = rep(c(TRUE, FALSE), 5),
    date = Sys.Date() + 1:10,
    stringsAsFactors = FALSE
  )

  expect_silent(plot_data_health(df_all_types, interactive = FALSE))
})
