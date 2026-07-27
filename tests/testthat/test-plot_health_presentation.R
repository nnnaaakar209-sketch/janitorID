# ============================================================================
# tests/testthat/test-plot_health_presentation.R
# Unit Test untuk fungsi plot_health_presentation()
# ============================================================================

# ----------------------------------------------------------------------------
# TEST 1: Missing Type
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles 'missing' type correctly", {
  data("airquality")

  p <- plot_health_presentation(airquality, type = "missing")
  expect_s3_class(p, "ggplot")

  # Test dengan data tanpa missing
  data("mtcars")
  p2 <- plot_health_presentation(mtcars, type = "missing")
  expect_s3_class(p2, "ggplot")

  # Test dengan data frame kosong
  df_empty <- data.frame()
  expect_error(
    plot_health_presentation(df_empty, type = "missing"),
    "data.frame"
  )
})

# ----------------------------------------------------------------------------
# TEST 2: Correlation Type
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles 'correlation' type correctly", {
  data("mtcars")

  p <- plot_health_presentation(mtcars, type = "correlation")
  expect_s3_class(p, "ggplot")

  # Test dengan data iris
  data("iris")
  p2 <- plot_health_presentation(iris, type = "correlation")
  expect_s3_class(p2, "ggplot")
})

test_that("plot_health_presentation handles correlation with insufficient numeric columns", {
  # Data dengan 1 kolom numerik
  df_single_num <- data.frame(
    a = 1:5,
    b = c("x", "y", "z", "a", "b"),
    stringsAsFactors = FALSE
  )

  # Harusnya error atau return plot kosong
  expect_silent(plot_health_presentation(df_single_num, type = "correlation"))

  # Data tanpa kolom numerik
  df_non_num <- data.frame(
    a = c("x", "y", "z"),
    b = c("m", "n", "o"),
    stringsAsFactors = FALSE
  )

  expect_silent(plot_health_presentation(df_non_num, type = "correlation"))
})

# ----------------------------------------------------------------------------
# TEST 3: Outlier Type
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles 'outlier' type correctly", {
  data("iris")

  p <- plot_health_presentation(iris, type = "outlier")
  expect_s3_class(p, "ggplot")

  # Test dengan data yang ada outlier
  data("mtcars")
  p2 <- plot_health_presentation(mtcars, type = "outlier")
  expect_s3_class(p2, "ggplot")
})

test_that("plot_health_presentation handles outlier with no numeric columns", {
  df_non_num <- data.frame(
    a = c("x", "y", "z"),
    b = c("m", "n", "o"),
    stringsAsFactors = FALSE
  )

  p_empty <- plot_health_presentation(df_non_num, type = "outlier")
  expect_s3_class(p_empty, "ggplot")

  # Cek apakah ada pesan "Tidak ada kolom numerik"
  expect_true(any(grepl("Tidak ada kolom numerik", capture.output(print(p_empty)))))
})

test_that("plot_health_presentation handles is_cleaned = TRUE for outlier", {
  data("mtcars")

  # is_cleaned = FALSE (default)
  p1 <- plot_health_presentation(mtcars, type = "outlier", is_cleaned = FALSE)
  expect_s3_class(p1, "ggplot")

  # is_cleaned = TRUE
  p2 <- plot_health_presentation(mtcars, type = "outlier", is_cleaned = TRUE)
  expect_s3_class(p2, "ggplot")

  # Cek apakah ada pesan "data sudah dibersihkan"
  output <- capture.output(print(p2))
  expect_true(any(grepl("data sudah dibersihkan", output)))
})

# ----------------------------------------------------------------------------
# TEST 4: Distribution Type
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles 'distribution' type correctly", {
  data("iris")

  p <- plot_health_presentation(iris, type = "distribution")
  expect_s3_class(p, "ggplot")

  # Test dengan data mtcars
  data("mtcars")
  p2 <- plot_health_presentation(mtcars, type = "distribution")
  expect_s3_class(p2, "ggplot")
})

test_that("plot_health_presentation handles distribution with no numeric columns", {
  df_non_num <- data.frame(
    a = c("x", "y", "z"),
    b = c("m", "n", "o"),
    stringsAsFactors = FALSE
  )

  p_empty <- plot_health_presentation(df_non_num, type = "distribution")
  expect_s3_class(p_empty, "ggplot")

  # Cek apakah ada pesan "Tidak ada kolom numerik"
  expect_true(any(grepl("Tidak ada kolom numerik", capture.output(print(p_empty)))))
})

# ----------------------------------------------------------------------------
# TEST 5: Validasi Type Argument
# ----------------------------------------------------------------------------

test_that("plot_health_presentation validates type argument", {
  data("iris")

  # Type yang valid
  expect_silent(plot_health_presentation(iris, type = "missing"))
  expect_silent(plot_health_presentation(iris, type = "correlation"))
  expect_silent(plot_health_presentation(iris, type = "outlier"))
  expect_silent(plot_health_presentation(iris, type = "distribution"))

  # Type yang tidak valid
  expect_error(
    plot_health_presentation(iris, type = "invalid_type"),
    "'arg' should be one of"
  )

  expect_error(
    plot_health_presentation(iris, type = "heatmap"),
    "'arg' should be one of"
  )
})

# ----------------------------------------------------------------------------
# TEST 6: Validasi Input Data
# ----------------------------------------------------------------------------

test_that("plot_health_presentation validates input data", {
  # Input harus data frame
  expect_error(
    plot_health_presentation(list(), type = "missing"),
    "data.frame"
  )

  expect_error(
    plot_health_presentation(c(1, 2, 3), type = "missing"),
    "data.frame"
  )

  # Data frame kosong
  df_empty <- data.frame()
  expect_error(
    plot_health_presentation(df_empty, type = "missing"),
    "data.frame"
  )
})

# ----------------------------------------------------------------------------
# TEST 7: Output Structure
# ----------------------------------------------------------------------------

test_that("plot_health_presentation returns ggplot object", {
  data("iris")

  # Semua type harus return ggplot
  types <- c("missing", "correlation", "outlier", "distribution")

  for (t in types) {
    p <- plot_health_presentation(iris, type = t)
    expect_s3_class(p, "ggplot")
  }
})

# ----------------------------------------------------------------------------
# TEST 8: Data dengan Nama Kolom Aneh
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles weird column names", {
  df_aneh <- data.frame(
    "Kolom 1" = 1:5,
    "Kolom-2" = 6:10,
    "Kolom_3" = 11:15,
    check.names = FALSE
  )

  # Harusnya berjalan tanpa error
  expect_silent(plot_health_presentation(df_aneh, type = "missing"))
  expect_silent(plot_health_presentation(df_aneh, type = "correlation"))
  expect_silent(plot_health_presentation(df_aneh, type = "outlier"))
  expect_silent(plot_health_presentation(df_aneh, type = "distribution"))
})

# ----------------------------------------------------------------------------
# TEST 9: Data dengan Missing Values
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles data with missing values", {
  data("airquality")

  # Semua type harus berjalan dengan data yang ada missing
  expect_silent(plot_health_presentation(airquality, type = "missing"))
  expect_silent(plot_health_presentation(airquality, type = "correlation"))
  expect_silent(plot_health_presentation(airquality, type = "outlier"))
  expect_silent(plot_health_presentation(airquality, type = "distribution"))
})

# ----------------------------------------------------------------------------
# TEST 10: Data dengan Banyak Kolom
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles many columns", {
  # Buat data dengan 20 kolom
  df_banyak <- as.data.frame(matrix(rnorm(400), nrow = 20, ncol = 20))
  names(df_banyak) <- paste0("col_", 1:20)

  # Harusnya berjalan tanpa error
  expect_silent(plot_health_presentation(df_banyak, type = "missing"))
  expect_silent(plot_health_presentation(df_banyak, type = "correlation"))
  expect_silent(plot_health_presentation(df_banyak, type = "outlier"))
  expect_silent(plot_health_presentation(df_banyak, type = "distribution"))
})

# ----------------------------------------------------------------------------
# TEST 11: Plot Titles
# ----------------------------------------------------------------------------

test_that("plot_health_presentation generates correct titles", {
  data("iris")

  p <- plot_health_presentation(iris, type = "missing")

  # Cek apakah title mengandung nama data
  title_text <- capture.output(print(p))
  expect_true(any(grepl("iris", title_text)))
})

# ----------------------------------------------------------------------------
# TEST 12: Data dengan Semua Nilai Sama
# ----------------------------------------------------------------------------

test_that("plot_health_presentation handles constant values", {
  df_constant <- data.frame(
    a = rep(5, 10),
    b = rep(10, 10),
    c = rep(15, 10)
  )

  # Harusnya berjalan (IQR = 0, tidak ada outlier)
  expect_silent(plot_health_presentation(df_constant, type = "outlier"))
  expect_silent(plot_health_presentation(df_constant, type = "correlation"))
  expect_silent(plot_health_presentation(df_constant, type = "distribution"))
})
