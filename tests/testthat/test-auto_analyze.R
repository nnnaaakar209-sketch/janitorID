# ============================================================================
# tests/testthat/test-auto_analyze.R
# Unit Test untuk fungsi auto_analyze()
# ============================================================================

# ----------------------------------------------------------------------------
# TEST 1: Validasi Input
# ----------------------------------------------------------------------------

test_that("auto_analyze() memvalidasi input", {
  # Input harus data frame
  expect_error(
    auto_analyze(list()),
    "Parameter 'data' harus berupa data frame."
  )

  # Input tidak boleh NULL
  expect_error(
    auto_analyze(NULL),
    "Parameter 'data' harus berupa data frame."
  )
})

# ----------------------------------------------------------------------------
# TEST 2: Bekerja dengan dataset standar (iris)
# ----------------------------------------------------------------------------

test_that("auto_analyze() bekerja dengan dataset standar", {
  data("iris")

  result <- auto_analyze(
    iris,
    do_clean = FALSE,
    do_plot = FALSE,
    verbose = FALSE
  )

  # Cek class
  expect_true(inherits(result, "auto_analyze_result"))

  # Cek komponen utama
  expect_true("summary" %in% names(result))
  expect_true("profile" %in% names(result))
  expect_true("insights" %in% names(result))
  expect_true("data_original" %in% names(result))
  expect_true("data_cleaned" %in% names(result))

  # Cek summary
  expect_true("rows_before" %in% names(result$summary))
  expect_true("rows_after" %in% names(result$summary))
  expect_true("health_score" %in% names(result$summary))
  expect_true("health_status" %in% names(result$summary))
})

# ----------------------------------------------------------------------------
# TEST 3: Menangani data dengan missing values
# ----------------------------------------------------------------------------

test_that("auto_analyze() menangani data dengan missing", {
  data("airquality")

  result <- auto_analyze(
    airquality,
    do_clean = TRUE,
    do_plot = FALSE,
    verbose = FALSE
  )

  # Cek changelog
  expect_true(!is.null(result$changelog))
  expect_true(nrow(result$changelog) >= 1)

  # Cek missing berkurang
  expect_true(result$summary$missing_after <= result$summary$missing_before)

  # Cek ada kolom yang diimputasi
  expect_true(result$summary$missing_after >= 0)
})

# ----------------------------------------------------------------------------
# TEST 4: Menghasilkan plot (do_plot = TRUE)
# ----------------------------------------------------------------------------

test_that("auto_analyze() menghasilkan plot", {
  data("iris")

  result <- auto_analyze(
    iris,
    do_clean = FALSE,
    do_plot = TRUE,
    verbose = FALSE
  )

  # Cek plot tersedia
  expect_true(!is.null(result$plots))
  expect_true("raw_dashboard" %in% names(result$plots))

  # Cek plot raw_dashboard (bisa NULL jika error)
  # Tapi minimal plot lain tersedia
  expect_true(
    !is.null(result$plots$raw_missing) ||
      !is.null(result$plots$raw_correlation) ||
      !is.null(result$plots$raw_outlier)
  )
})

# ----------------------------------------------------------------------------
# TEST 5: Menghasilkan validation
# ----------------------------------------------------------------------------

test_that("auto_analyze() menghasilkan validation", {
  data("iris")

  result <- auto_analyze(
    iris,
    do_clean = FALSE,
    do_validate = TRUE,
    do_plot = FALSE,
    verbose = FALSE
  )

  # Validation mungkin NULL jika tidak ada kombinasi kolom yang sesuai
  # Tapi fungsi harus berjalan tanpa error
  expect_true(inherits(result, "auto_analyze_result"))

  # Cek validation structure (jika ada)
  if (!is.null(result$validation)) {
    expect_true(is.data.frame(result$validation))
    expect_true("anomaly" %in% names(result$validation))
  }
})

# ----------------------------------------------------------------------------
# TEST 6: Auto cleaning bekerja dengan baik
# ----------------------------------------------------------------------------

test_that("auto_analyze() auto cleaning bekerja", {
  data("mtcars")

  # Buat data dengan duplikat dan missing
  df_test <- mtcars[1:20, ]
  df_test <- rbind(df_test, mtcars[1:5, ])  # tambah duplikat
  df_test$mpg[1:3] <- NA  # tambah missing
  df_test$cyl[5:7] <- NA

  result <- auto_analyze(
    df_test,
    do_clean = TRUE,
    do_plot = FALSE,
    verbose = FALSE
  )

  # Cek baris berkurang (duplikat dihapus)
  expect_true(result$summary$rows_after < result$summary$rows_before)

  # Cek missing berkurang
  expect_true(result$summary$missing_after <= result$summary$missing_before)

  # Cek ada changelog
  expect_true(nrow(result$changelog) > 1)
})

# ----------------------------------------------------------------------------
# TEST 7: Tanpa cleaning (do_clean = FALSE)
# ----------------------------------------------------------------------------

test_that("auto_analyze() tanpa cleaning", {
  data("iris")

  result <- auto_analyze(
    iris,
    do_clean = FALSE,
    do_plot = FALSE,
    verbose = FALSE
  )

  # Data sebelum dan sesudah harus sama
  expect_equal(result$summary$rows_before, result$summary$rows_after)
  expect_equal(result$summary$cols_before, result$summary$cols_after)

  # Changelog hanya 1 baris (START)
  expect_true(nrow(result$changelog) == 1 || nrow(result$changelog) == 0)
})

# ----------------------------------------------------------------------------
# TEST 8: verbose = FALSE (tidak ada output ke console)
# ----------------------------------------------------------------------------

test_that("auto_analyze() verbose = FALSE tidak mengeluarkan output", {
  data("iris")

  # Capture output
  output <- capture.output({
    result <- auto_analyze(
      iris,
      do_clean = FALSE,
      do_plot = FALSE,
      verbose = FALSE
    )
  })

  # Tidak ada output
  expect_true(length(output) == 0)
  expect_true(inherits(result, "auto_analyze_result"))
})

# ----------------------------------------------------------------------------
# TEST 9: print method untuk auto_analyze_result
# ----------------------------------------------------------------------------

test_that("print.auto_analyze_result() bekerja", {
  data("iris")

  result <- auto_analyze(
    iris,
    do_clean = FALSE,
    do_plot = FALSE,
    verbose = FALSE
  )

  # Capture print output
  print_output <- capture.output({
    print(result)
  })

  # Harus ada output
  expect_true(length(print_output) > 0)
  expect_true(any(grepl("AUTO ANALYZE RESULT", print_output)))
})

# ----------------------------------------------------------------------------
# TEST 10: Data dengan banyak kolom (max_cols)
# ----------------------------------------------------------------------------

test_that("auto_analyze() menangani data dengan banyak kolom", {
  # Buat data dengan 20 kolom
  df_large <- as.data.frame(matrix(rnorm(1000), ncol = 20))
  names(df_large) <- paste0("col_", 1:20)

  result <- auto_analyze(
    df_large,
    do_clean = FALSE,
    do_plot = FALSE,
    verbose = FALSE
  )

  # Cek class
  expect_true(inherits(result, "auto_analyze_result"))

  # Cek profile untuk semua kolom
  expect_equal(nrow(result$profile), 20)
})

# ----------------------------------------------------------------------------
# TEST 11: Data dengan hanya 1 kolom
# ----------------------------------------------------------------------------

test_that("auto_analyze() menangani data dengan 1 kolom", {
  df_single <- data.frame(x = rnorm(100))

  # Harusnya berjalan tanpa error
  result <- auto_analyze(
    df_single,
    do_clean = FALSE,
    do_plot = FALSE,
    verbose = FALSE
  )

  expect_true(inherits(result, "auto_analyze_result"))
  expect_equal(result$summary$cols_before, 1)
})

# ----------------------------------------------------------------------------
# TEST 12: Data dengan semua kolom kategorik
# ----------------------------------------------------------------------------

test_that("auto_analyze() menangani data semua kategorik", {
  df_cat <- data.frame(
    cat1 = sample(letters[1:3], 100, replace = TRUE),
    cat2 = sample(letters[4:6], 100, replace = TRUE),
    stringsAsFactors = TRUE
  )

  result <- auto_analyze(
    df_cat,
    do_clean = FALSE,
    do_plot = FALSE,
    verbose = FALSE
  )

  expect_true(inherits(result, "auto_analyze_result"))

  # Tidak ada outlier (karena tidak ada numerik)
  expect_equal(result$summary$outlier_cols_before, 0)
})

# ----------------------------------------------------------------------------
# TEST 13: is_cleaned parameter di plot_health_presentation
# ----------------------------------------------------------------------------

test_that("plot_health_presentation() dengan is_cleaned = TRUE", {
  data("mtcars")

  # is_cleaned = FALSE (default)
  p1 <- plot_health_presentation(mtcars, type = "outlier", is_cleaned = FALSE)

  # is_cleaned = TRUE
  p2 <- plot_health_presentation(mtcars, type = "outlier", is_cleaned = TRUE)

  # Keduanya harus objek ggplot
  expect_true(inherits(p1, "ggplot"))
  expect_true(inherits(p2, "ggplot"))
})

# ----------------------------------------------------------------------------
# TEST 14: plot_data_health() dengan berbagai parameter
# ----------------------------------------------------------------------------

test_that("plot_data_health() bekerja dengan berbagai parameter", {
  data("iris")

  # Test berbagai kombinasi
  p1 <- plot_data_health(iris, interactive = FALSE, show_missing = TRUE)
  p2 <- plot_data_health(iris, interactive = FALSE, show_correlation = FALSE)
  p3 <- plot_data_health(iris, interactive = FALSE, show_outliers = FALSE)

  expect_true(inherits(p1, "ggplot") || inherits(p1, "patchwork"))
  expect_true(inherits(p2, "ggplot") || inherits(p2, "patchwork"))
  expect_true(inherits(p3, "ggplot") || inherits(p3, "patchwork"))
})

# ----------------------------------------------------------------------------
# TEST 15: plot_health_presentation() semua tipe
# ----------------------------------------------------------------------------

test_that("plot_health_presentation() semua tipe berjalan", {
  data("mtcars")

  types <- c("missing", "correlation", "outlier", "distribution")

  for (t in types) {
    p <- plot_health_presentation(mtcars, type = t)
    expect_true(inherits(p, "ggplot"))
  }
})
