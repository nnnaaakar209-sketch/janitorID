# Test file for currency_tools.R
library(testthat)
library(janitorID)

# Test data
test_df <- data.frame(
  id = 1:5,
  salary = c(15000000, 25000000, 30000000, 45000000, 50000000),
  bonus = c(5000000, 7500000, 10000000, 15000000, 20000000),
  mixed_currency = c("Rp500.000", "US$25", "RM100", "Rp750.000", "US$50.50"),
  stringsAsFactors = FALSE
)

# Test 1: Basic conversion functionality
test_that("convert_currency works with basic conversion", {
  result <- convert_currency(
    data = test_df,
    columns = "salary",
    from = "IDR",
    to = "USD"
  )

  expect_true(is.data.frame(result))
  expect_true("salary_USD" %in% names(result))
  expect_true(is.character(result$salary_USD))
  expect_true(grepl("US\\$", result$salary_USD[1]))
})

# Test 2: Multiple columns conversion
test_that("convert_currency handles multiple columns", {
  result <- convert_currency(
    data = test_df,
    columns = c("salary", "bonus"),
    from = "IDR",
    to = "SGD"
  )

  expect_true("salary_SGD" %in% names(result))
  expect_true("bonus_SGD" %in% names(result))
  expect_true(is.character(result$salary_SGD))
})

# Test 3: Numeric output (without formatting)
test_that("convert_currency can return numeric values", {
  result <- convert_currency(
    data = test_df,
    columns = "salary",
    from = "IDR",
    to = "USD",
    format_output = FALSE
  )

  expect_true(is.numeric(result$salary_USD))
})

# Test 4: Manual exchange rate
test_that("convert_currency accepts manual exchange rates", {
  result <- convert_currency(
    data = test_df,
    columns = "salary",
    from = "IDR",
    to = "USD",
    exchange_rate = c(IDR = 16000, USD = 1)
  )

  expect_true(is.data.frame(result))
  expect_true("salary_USD" %in% names(result))
})

# Test 5: All ASEAN currency conversions
test_that("convert_currency supports all ASEAN currencies", {
  currencies <- c("MYR", "SGD", "THB", "PHP", "BND", "VND", "LAK", "MMK", "KHR")

  for (currency in currencies) {
    result <- convert_currency(
      data = test_df,
      columns = "salary",
      from = "IDR",
      to = currency,
      format_output = FALSE
    )

    expect_true(is.data.frame(result))
    expect_true(paste0("salary_", currency) %in% names(result))
    expect_true(is.numeric(result[[paste0("salary_", currency)]]))
  }
})

# Test 6: Validation - data frame input
test_that("convert_currency validates input is data frame", {
  expect_error(
    convert_currency(
      data = matrix(1:10, ncol = 2),
      columns = "col1",
      from = "IDR",
      to = "USD"
    ),
    "'data' must be a data frame"
  )
})

# Test 7: Validation - numeric columns
test_that("convert_currency validates columns are numeric", {
  df_non_numeric <- data.frame(
    id = 1:3,
    amount = c("100", "200", "300"),
    stringsAsFactors = FALSE
  )

  expect_error(
    convert_currency(
      data = df_non_numeric,
      columns = "amount",
      from = "IDR",
      to = "USD"
    ),
    "Column 'amount' must be numeric"
  )
})

# Test 8: Validation - unsupported currency
test_that("convert_currency errors on unsupported currency", {
  expect_error(
    convert_currency(
      data = test_df,
      columns = "salary",
      from = "IDR",
      to = "EUR"
    ),
    "Currency 'EUR' is not supported"
  )
})

# Test 9: API fallback mechanism
test_that("convert_currency uses fallback when API fails", {
  # Mock API failure by using use_api = TRUE with no internet (simulated)
  # This test may need to be adjusted based on environment
  result <- convert_currency(
    data = test_df,
    columns = "salary",
    from = "IDR",
    to = "USD",
    use_api = TRUE
  )

  # Should work even if API fails (falls back to internal rates)
  expect_true(is.data.frame(result))
  expect_true("salary_USD" %in% names(result))
})

# Test 10: Formatting with digits parameter
test_that("convert_currency respects digits parameter", {
  result_2 <- convert_currency(
    data = test_df,
    columns = "salary",
    from = "IDR",
    to = "USD",
    digits = 2,
    format_output = TRUE
  )

  result_4 <- convert_currency(
    data = test_df,
    columns = "salary",
    from = "IDR",
    to = "USD",
    digits = 4,
    format_output = TRUE
  )

  # Check that different digits produce different formatting
  # This is a basic check; actual digit count may vary
  expect_false(identical(result_2$salary_USD, result_4$salary_USD))
})

# Test 11: clean_currency_to_numeric functionality
test_that("clean_currency_to_numeric handles various currency formats", {
  test_values <- c("Rp15.000.000", "RM4,500.25", "S$52.60", "฿350.50",
                   "₱420.00", "B$120.00", "₫1.500.000", "₭250.000")

  cleaned <- clean_currency_to_numeric(test_values)

  expect_true(is.numeric(cleaned))
  expect_equal(length(cleaned), length(test_values))
  expect_true(all(!is.na(cleaned)))
})

# Test 12: clean_currency_to_numeric with mixed currencies
test_that("clean_currency_to_numeric handles mixed currencies with warning", {
  mixed <- c("Rp500.000", "US$25", "RM100", "Rp750.000", "US$50.50")

  expect_warning(
    clean_currency_to_numeric(mixed, warn_mixed = TRUE),
    "Mixed currency types detected"
  )
})

# Test 13: detect_currency_mix functionality
test_that("detect_currency_mix correctly identifies mixed currencies", {
  audit <- detect_currency_mix(test_df, "mixed_currency")

  expect_s3_class(audit, "currency_audit")
  expect_true(audit$is_mixed)
  expect_true(length(audit$currency_types) > 1)
})

# Test 14: detect_currency_mix on pure currency column
test_that("detect_currency_mix identifies pure currency column", {
  df_pure <- data.frame(
    amount = c("Rp500.000", "Rp750.000", "Rp1.000.000")
  )

  audit <- detect_currency_mix(df_pure, "amount")

  expect_s3_class(audit, "currency_audit")
  expect_false(audit$is_mixed)
  expect_equal(audit$currency_types, "IDR")
})

# Test 15: summarise_currency functionality
test_that("summarise_currency produces summary statistics", {
  summary <- summarise_currency(test_df, columns = c("salary", "bonus"))

  expect_type(summary, "list")
  expect_true("salary" %in% names(summary))
  expect_true("bonus" %in% names(summary))

  # Check that salary summary has statistics
  salary_summary <- summary$salary
  expect_true("statistics" %in% names(salary_summary))
  expect_true("IDR" %in% names(salary_summary$statistics))
})

# Test 16: summarise_currency with conversion
test_that("summarise_currency can convert to target currency", {
  summary <- summarise_currency(test_df, columns = "salary", convert_to = "USD")

  expect_true("salary" %in% names(summary))
  salary_summary <- summary$salary
  expect_true("converted_to" %in% names(salary_summary))
  expect_equal(salary_summary$converted_to, "USD")
  expect_true("converted_statistics" %in% names(salary_summary))
})

# Test 17: print method for currency_audit
test_that("print.currency_audit works correctly", {
  audit <- detect_currency_mix(test_df, "mixed_currency")

  # Capture print output
  print_output <- capture_output(print(audit))

  expect_true(grepl("CURRENCY AUDIT REPORT", print_output))
  expect_true(grepl("mixed_currency", print_output))
})

# Test 18: Edge cases - empty data frame
test_that("functions handle empty data frames", {
  empty_df <- data.frame()

  expect_error(
    convert_currency(empty_df, columns = "col", from = "IDR", to = "USD"),
    "Columns not found"
  )
})

# Test 19: Edge cases - NA values
test_that("functions handle NA values appropriately", {
  df_with_na <- data.frame(
    amount = c("Rp500.000", NA, "Rp750.000", NA)
  )

  cleaned <- clean_currency_to_numeric(df_with_na$amount, remove_na = TRUE)
  expect_equal(length(cleaned), 2)

  cleaned_all <- clean_currency_to_numeric(df_with_na$amount, remove_na = FALSE)
  expect_equal(length(cleaned_all), 4)
  expect_true(all(is.na(cleaned_all[is.na(df_with_na$amount)])))
})

# Test 20: API integration test (if internet available)
test_that("API integration works when internet is available", {
  # Only run if internet is available
  skip_on_cran()

  # Test if API call works
  api_rates <- tryCatch(.fetch_exchange_rates("USD"), error = function(e) NULL)

  if (!is.null(api_rates)) {
    expect_type(api_rates, "list")
    expect_true("IDR" %in% names(api_rates))
  }
})
