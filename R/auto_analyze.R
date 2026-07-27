#' Plot Distribusi Kategorik untuk Presentasi
#'
#' @param data Data frame yang akan dianalisis
#' @return Objek ggplot
#' @export
plot_categorical_presentation <- function(data) {
  if (!requireNamespace("dplyr", quietly = TRUE) ||
      !requireNamespace("tidyr", quietly = TRUE) ||
      !requireNamespace("ggplot2", quietly = TRUE)) {
    stop("Package 'dplyr', 'tidyr', dan 'ggplot2' wajib diinstal.")
  }

  cat_cols <- names(data)[sapply(data, function(x) is.factor(x) || is.character(x))]
  if (length(cat_cols) == 0) return(NULL)

  cat_cols <- cat_cols[1:min(4, length(cat_cols))]

  df_long <- data %>%
    dplyr::select(dplyr::all_of(cat_cols)) %>%
    tidyr::pivot_longer(cols = dplyr::everything(), names_to = "Variable", values_to = "Category") %>%
    dplyr::filter(!is.na(Category)) %>%
    dplyr::count(Variable, Category) %>%
    dplyr::group_by(Variable) %>%
    dplyr::mutate(Pct = n / sum(n) * 100) %>%
    dplyr::ungroup()

  ggplot2::ggplot(df_long, ggplot2::aes(x = stats::reorder(Category, n), y = n, fill = Variable)) +
    ggplot2::geom_col(show.legend = FALSE, alpha = 0.85) +
    ggplot2::geom_text(ggplot2::aes(label = paste0(n, " (", round(Pct, 1), "%)")),
                       hjust = -0.1, size = 3) +
    ggplot2::coord_flip() +
    ggplot2::facet_wrap(~Variable, scales = "free_y", ncol = 2) +
    ggplot2::scale_fill_brewer(palette = "Set2") +
    ggplot2::theme_minimal(base_size = 12) +
    ggplot2::labs(
      title = "Distribusi Frekuensi Variabel Kategorik",
      subtitle = "Menampilkan frekuensi dan persentase tiap kategori",
      x = "Kategori",
      y = "Jumlah (Count)"
    ) +
    ggplot2::theme(
      plot.title = ggplot2::element_text(face = "bold", size = 14),
      panel.grid.minor = ggplot2::element_blank()
    )
}

#' Auto Analyze - All-in-One Data Analysis & Cleaning Pipeline
#'
#' Fungsi ini melakukan analisis dan pembersihan data secara otomatis:
#' - Data profiling (struktur, missing, unique)
#' - Deteksi outlier dengan IQR
#' - Auto cleaning (missing imputation, outlier removal, duplicate removal)
#' - Cross validation distribusi
#' - Health dashboard visualisasi
#' - Skor kesehatan data (0-100)
#'
#' @param data Data frame yang akan dianalisis
#' @param do_clean Apakah akan melakukan auto cleaning? (default: TRUE)
#' @param do_validate Apakah akan melakukan cross validation? (default: TRUE)
#' @param do_plot Apakah akan menampilkan plot? (default: TRUE)
#' @param verbose Tampilkan detail proses ke console
#'
#' @return List berisi semua hasil analisis dengan kelas 'auto_analyze_result'
#' @export
auto_analyze <- function(
    data,
    do_clean = TRUE,
    do_validate = TRUE,
    do_plot = TRUE,
    verbose = TRUE
) {

  # --- 1. VALIDASI ---
  if (!is.data.frame(data)) {
    stop("Parameter 'data' harus berupa data frame.")
  }

  data_name <- deparse(substitute(data))

  if (verbose) {
    cat("\n", rep("=", 70), "\n", sep = "")
    cat(" AUTO ANALYZE - All-in-One Data Analysis\n")
    cat(rep("=", 70), "\n", sep = "")
    cat(" Dataset:", data_name, "\n")
    cat(" Dimensi:", nrow(data), "baris x", ncol(data), "kolom\n")
    cat(rep("=", 70), "\n\n", sep = "")
  }

  # --- 2. DATA PROFILE ---
  if (verbose) cat(" [1/5] Membuat Data Profile...\n")

  profile <- data.frame(
    Kolom = names(data),
    Tipe = sapply(data, function(x) class(x)[1]),
    N_Unique = sapply(data, function(x) length(unique(x[!is.na(x)]))),
    N_Missing = sapply(data, function(x) sum(is.na(x))),
    Pct_Missing = round(sapply(data, function(x) sum(is.na(x)) / length(x) * 100), 2),
    stringsAsFactors = FALSE
  )

  # --- 3. DATA INSIGHTS & SKORING ---
  if (verbose) cat(" [2/5] Menghasilkan Data Insights...\n")

  n_rows <- nrow(data)
  n_cols <- ncol(data)
  missing_pct <- round(sum(is.na(data)) / (n_rows * n_cols) * 100, 2)
  dup_count <- sum(duplicated(data))

  numeric_cols <- names(data)[sapply(data, is.numeric)]
  cat_cols <- names(data)[sapply(data, function(x) is.factor(x) || is.character(x))]

  issues <- list()
  recs <- list()

  # Missing Values
  if (missing_pct > 0) {
    high_missing <- names(data)[sapply(data, function(x) sum(is.na(x)) / length(x) > 0.2)]
    if (length(high_missing) > 0) {
      issues <- c(issues, paste("Kolom dengan missing >20%:", paste(high_missing, collapse = ", ")))
      recs <- c(recs, paste("Hapus atau imputasi kolom:", paste(high_missing, collapse = ", ")))
    } else {
      issues <- c(issues, paste(missing_pct, "% data hilang (masih wajar)"))
      recs <- c(recs, "Gunakan auto cleaner bawaan untuk menangani missing")
    }
  } else {
    issues <- c(issues, "Tidak ada missing values!")
  }

  # Duplikat
  if (dup_count > 0) {
    issues <- c(issues, paste(dup_count, "baris duplikat ditemukan"))
    recs <- c(recs, paste("Gunakan dplyr::distinct() untuk menghapus", dup_count, "duplikat"))
  } else {
    issues <- c(issues, "Tidak ada duplikat!")
  }

  # --- OUTLIER DETECTION ---
  outlier_cols <- c()
  outlier_details <- list()
  total_outliers_before <- 0

  for (col in numeric_cols) {
    vals <- data[[col]][!is.na(data[[col]])]
    if (length(vals) > 3) {
      Q1 <- stats::quantile(vals, 0.25, na.rm = TRUE)
      Q3 <- stats::quantile(vals, 0.75, na.rm = TRUE)
      IQR_val <- Q3 - Q1
      if (IQR_val > 0) {
        n_out <- sum(vals < (Q1 - 1.5 * IQR_val) | vals > (Q3 + 1.5 * IQR_val))
        if (n_out > 0) {
          outlier_cols <- c(outlier_cols, col)
          total_outliers_before <- total_outliers_before + n_out
          outlier_details[[col]] <- list(
            n_outliers = n_out,
            pct_outliers = round(n_out / length(vals) * 100, 2),
            total_values = length(vals),
            lower_bound = Q1 - 1.5 * IQR_val,
            upper_bound = Q3 + 1.5 * IQR_val
          )
        }
      }
    }
  }

  if (length(outlier_cols) > 0) {
    issues <- c(issues, paste("Outlier dominan di:", paste(outlier_cols, collapse = ", ")))
    recs <- c(recs, "Pertimbangkan filter IQR, transformasi log, atau winsorizing")
  }

  # Skor Kesehatan
  score <- 100
  score <- score - (missing_pct * 2)
  score <- score - (dup_count / max(n_rows, 1) * 50)
  score <- score - (length(outlier_cols) * 3)
  score <- max(0, min(100, round(score)))

  status <- if (score >= 80) "SANGAT BAIK" else
    if (score >= 60) "BAIK" else
      if (score >= 40) "PERLU PERHATIAN" else "PERLU CLEANING"

  insights <- list(
    score = score,
    status = status,
    issues = issues,
    recommendations = recs,
    outlier_summary = list(
      total_cols_with_outliers = length(outlier_cols),
      outlier_cols = outlier_cols,
      outlier_details = outlier_details,
      total_outliers = total_outliers_before
    )
  )

  # --- 4. CROSS VALIDATION ---
  validate_result <- NULL
  if (do_validate) {
    if (verbose) cat(" [3/5] Melakukan Cross Validation...\n")

    if (length(cat_cols) >= 2) {
      row_var <- cat_cols[1]
      col_var <- cat_cols[2]

      if (verbose) cat("    * Validasi Distribusi Kelompok:", row_var, "vs", col_var, "\n")

      tryCatch({
        contingency <- data %>%
          dplyr::count(!!rlang::sym(row_var), !!rlang::sym(col_var)) %>%
          dplyr::group_by(!!rlang::sym(row_var)) %>%
          dplyr::mutate(
            total_row = sum(.data$n),
            proportion = .data$n / .data$total_row,
            percent = round(.data$proportion * 100, 1)
          ) %>%
          dplyr::ungroup()

        contingency <- contingency %>%
          dplyr::mutate(
            anomaly = .data$proportion < 0.05,
            anomaly_type = ifelse(.data$anomaly, "Anomali (probabilitas rendah)", "Normal")
          )

        validate_result <- contingency

        if (verbose) {
          n_anom <- sum(contingency$anomaly)
          if (n_anom > 0) {
            cat("    [!] Ditemukan", n_anom, "kombinasi kelompok anomali (frekuensi terlalu rendah)\n")
          } else {
            cat("    [OK] Tidak ada anomali distribusi kelompok terdeteksi\n")
          }
        }
      }, error = function(e) {
        if (verbose) cat("    [!] Gagal validasi:", e$message, "\n")
        validate_result <- NULL
      })
    } else {
      if (verbose) cat("    [!] Dibutuhkan minimal 2 kolom kategorik untuk cross-validation kelompok\n")
    }
  }

  # --- 5. AUTO CLEANER ENGINE ---
  clean_result <- NULL
  changelog <- data.frame(
    step = integer(), action = character(), rows_before = integer(), rows_after = integer(),
    cols_before = integer(), cols_after = integer(), missing_before = integer(), missing_after = integer(),
    stringsAsFactors = FALSE
  )
  current_data <- data
  rows_removed_by_outlier <- 0

  if (do_clean) {
    if (verbose) cat(" [4/5] Menjalankan Auto Cleaner...\n")

    log_step <- function(action, df_before, df_after) {
      step_num <- nrow(changelog) + 1
      new_row <- data.frame(
        step = step_num, action = action, rows_before = nrow(df_before), rows_after = nrow(df_after),
        cols_before = ncol(df_before), cols_after = ncol(df_after),
        missing_before = sum(is.na(df_before)), missing_after = sum(is.na(df_after)),
        stringsAsFactors = FALSE
      )
      changelog <<- rbind(changelog, new_row)
    }

    log_step("START", data, data)

    # Clean names
    df_before <- current_data
    if (requireNamespace("janitor", quietly = TRUE)) {
      current_data <- janitor::clean_names(current_data)
    } else {
      names(current_data) <- tolower(gsub("[^a-zA-Z0-9_]", "_", names(current_data)))
    }
    log_step("clean_names", df_before, current_data)

    # Handle missing values
    is_missing <- function(x) {
      missing_vals <- c("", " ", "-", "--", "n/a", "N/A", "null", "NULL", ".", "NA", "na")
      is.na(x) | (is.character(x) & trimws(x) %in% missing_vals)
    }

    if (any(sapply(current_data, function(x) any(is_missing(x))))) {
      df_before <- current_data

      # Numerik -> Median
      numeric_cols_clean <- names(current_data)[sapply(current_data, is.numeric)]
      for (col in numeric_cols_clean) {
        if (any(is_missing(current_data[[col]]))) {
          current_data[[col]][is_missing(current_data[[col]])] <- NA
          if (any(is.na(current_data[[col]]))) {
            med_val <- stats::median(current_data[[col]], na.rm = TRUE)
            current_data[[col]][is.na(current_data[[col]])] <- med_val
          }
        }
      }

      # Kategorik -> "Unknown"
      cat_cols_clean <- names(current_data)[sapply(current_data, function(x) is.character(x) || is.factor(x))]
      for (col in cat_cols_clean) {
        if (any(is_missing(current_data[[col]]))) {
          current_data[[col]][is_missing(current_data[[col]])] <- "Unknown"
          if (is.factor(current_data[[col]])) {
            if (!("Unknown" %in% levels(current_data[[col]]))) {
              levels(current_data[[col]]) <- c(levels(current_data[[col]]), "Unknown")
            }
          }
        }
      }
      log_step("handle_missing (impute_median_and_unknown)", df_before, current_data)
    }

    # Remove outliers (IQR method)
    df_before <- current_data
    numeric_cols_clean <- names(current_data)[sapply(current_data, is.numeric)]
    rows_before_outlier <- nrow(current_data)

    for (col in numeric_cols_clean) {
      vals <- current_data[[col]][!is.na(current_data[[col]])]
      if (length(vals) > 3) {
        Q1 <- stats::quantile(vals, 0.25, na.rm = TRUE)
        Q3 <- stats::quantile(vals, 0.75, na.rm = TRUE)
        IQR_val <- Q3 - Q1
        if (IQR_val > 0) {
          lower <- Q1 - 1.5 * IQR_val
          upper <- Q3 + 1.5 * IQR_val
          current_data <- current_data[
            is.na(current_data[[col]]) |
              (current_data[[col]] >= lower & current_data[[col]] <= upper),
          ]
        }
      }
    }

    rows_removed_by_outlier <- rows_before_outlier - nrow(current_data)
    if (rows_removed_by_outlier > 0) {
      log_step(paste("remove_outliers_iqr (removed", rows_removed_by_outlier, "rows)"), df_before, current_data)
    }

    # Remove duplicates
    df_before <- current_data
    current_data <- dplyr::distinct(current_data)
    if (nrow(df_before) != nrow(current_data)) {
      log_step("remove_duplicates", df_before, current_data)
    }

    clean_result <- list(data = current_data, changelog = changelog)

    if (verbose) {
      cat("    [OK] Auto cleaner selesai\n")
      cat("    * Baris:", nrow(data), "->", nrow(current_data), "\n")
      cat("    * Missing:", sum(is.na(data)), "->", sum(is.na(current_data)), "\n")
      if (rows_removed_by_outlier > 0) {
        cat("    * Outlier dihapus:", rows_removed_by_outlier, "baris\n")
      }
    }
  }

  # --- 6. PLOT GENERATION ---
  plot_raw_dashboard <- NULL
  plot_clean_dashboard <- NULL
  plot_raw_missing <- NULL
  plot_clean_missing <- NULL
  plot_raw_cor <- NULL
  plot_clean_cor <- NULL
  plot_raw_outlier <- NULL
  plot_clean_outlier <- NULL
  plot_raw_dist <- NULL
  plot_clean_dist <- NULL
  plot_raw_cat <- NULL
  plot_clean_cat <- NULL

  if (do_plot) {
    if (verbose) cat(" [5/5] Membuat Health Dashboard & Individual Plots...\n")

    # --- PLOT RAW ---
    if (verbose) cat("    * Membuat plot untuk data RAW...\n")

    plot_raw_dashboard <- tryCatch({
      plot_data_health(data, interactive = FALSE, title = "Sebelum Cleaning (Raw)", is_cleaned = FALSE)
    }, error = function(e) NULL)

    plot_raw_missing <- tryCatch(plot_health_presentation(data, type = "missing", is_cleaned = FALSE), error = function(e) NULL)
    plot_raw_cor <- tryCatch(plot_health_presentation(data, type = "correlation", is_cleaned = FALSE), error = function(e) NULL)
    plot_raw_outlier <- tryCatch(plot_health_presentation(data, type = "outlier", is_cleaned = FALSE), error = function(e) NULL)
    plot_raw_dist <- tryCatch(plot_health_presentation(data, type = "distribution", is_cleaned = FALSE), error = function(e) NULL)
    plot_raw_cat <- tryCatch(plot_categorical_presentation(data), error = function(e) NULL)

    # --- PLOT CLEANED ---
    if (do_clean) {
      if (verbose) cat("    * Membuat plot untuk data CLEANED...\n")

      data_for_plots <- current_data

      plot_clean_dashboard <- tryCatch({
        plot_data_health(data_for_plots, interactive = FALSE, title = "Setelah Cleaning (Cleaned)", is_cleaned = TRUE)
      }, error = function(e) NULL)

      plot_clean_missing <- tryCatch(plot_health_presentation(data_for_plots, type = "missing", is_cleaned = TRUE), error = function(e) NULL)
      plot_clean_cor <- tryCatch(plot_health_presentation(data_for_plots, type = "correlation", is_cleaned = TRUE), error = function(e) NULL)
      plot_clean_outlier <- tryCatch(plot_health_presentation(data_for_plots, type = "outlier", is_cleaned = TRUE), error = function(e) NULL)
      plot_clean_dist <- tryCatch(plot_health_presentation(data_for_plots, type = "distribution", is_cleaned = TRUE), error = function(e) NULL)
      plot_clean_cat <- tryCatch(plot_categorical_presentation(data_for_plots), error = function(e) NULL)

    } else {
      plot_clean_dashboard <- plot_raw_dashboard
      plot_clean_missing <- plot_raw_missing
      plot_clean_cor <- plot_raw_cor
      plot_clean_outlier <- plot_raw_outlier
      plot_clean_dist <- plot_raw_dist
      plot_clean_cat <- plot_raw_cat
    }

    if (verbose) cat("    [OK] Plot selesai dibuat\n")
  }

  # --- 7. BINDING OUTPUT LIST ---
  result <- list(
    data_original = data,
    data_cleaned = current_data,
    profile = profile,
    insights = insights,
    changelog = changelog,
    validation = validate_result,
    plots = list(
      raw_dashboard = plot_raw_dashboard,
      clean_dashboard = plot_clean_dashboard,
      raw_missing = plot_raw_missing,
      clean_missing = plot_clean_missing,
      raw_correlation = plot_raw_cor,
      clean_correlation = plot_clean_cor,
      raw_outlier = plot_raw_outlier,
      clean_outlier = plot_clean_outlier,
      raw_distribution = plot_raw_dist,
      clean_distribution = plot_clean_dist,
      raw_categorical = plot_raw_cat,
      clean_categorical = plot_clean_cat
    ),
    summary = list(
      rows_before = nrow(data),
      rows_after = nrow(current_data),
      cols_before = ncol(data),
      cols_after = ncol(current_data),
      missing_before = sum(is.na(data)),
      missing_after = sum(is.na(current_data)),
      outlier_cols_before = length(outlier_cols),
      outlier_cols_after = 0,
      outlier_rows_removed = rows_removed_by_outlier,
      outlier_details = outlier_details,
      outlier_cols_names = paste(outlier_cols, collapse = ", "),
      health_score = score,
      health_status = status
    )
  )

  class(result) <- "auto_analyze_result"

  # --- 8. AUTO-RENDER KE LAYAR ---
  if (verbose) {
    cat("\n", rep("=", 70), "\n", sep = "")
    cat(" AUTO ANALYZE SELESAI!\n")
    cat(rep("=", 70), "\n", sep = "")
    cat(" Ringkasan Akhir Pipeline:\n")
    cat("    * Hasil Data:", result$summary$rows_after, "baris x", result$summary$cols_after, "kolom\n")
    cat("    * Sisa Missing:", result$summary$missing_before, "->", result$summary$missing_after, "\n")
    if (result$summary$outlier_cols_before > 0) {
      cat("    * Outlier Kolom:", result$summary$outlier_cols_before, "kolom ->",
          result$summary$outlier_cols_after, "kolom (",
          result$summary$outlier_rows_removed, "baris dihapus)\n", sep = "")
      cat("    * Kolom:", result$summary$outlier_cols_names, "\n")
    }
    cat("    * Skor Kesehatan Awal:", result$summary$health_score, "/ 100 (", result$summary$health_status, ")\n")
    cat(rep("=", 70), "\n\n")
  }

  # Tampilkan PLOT CLEANED DASHBOARD
  if (do_plot && !is.null(result$plots$clean_dashboard)) {
    suppressWarnings(print(result$plots$clean_dashboard))
  } else if (do_plot && !is.null(result$plots$raw_dashboard)) {
    suppressWarnings(print(result$plots$raw_dashboard))
  }

  return(result)
}

#' Print method untuk objek auto_analyze_result
#'
#' @param x Objek auto_analyze_result
#' @param ... Parameter tambahan
#' @export
print.auto_analyze_result <- function(x, ...) {
  cat("\n", rep("=", 70), "\n", sep = "")
  cat(" REPORT: AUTO ANALYZE RESULT\n")
  cat(rep("=", 70), "\n", sep = "")

  cat("\n Ringkasan Matriks:\n")
  cat("    * Dimensi Data Akhir :", x$summary$rows_after, "baris x", x$summary$cols_after, "kolom\n")
  cat("    * Perubahan Missing  :", x$summary$missing_before, "->", x$summary$missing_after, "\n")

  # INFORMASI OUTLIER
  if (!is.null(x$summary$outlier_cols_before) && x$summary$outlier_cols_before > 0) {
    cat("    * Outlier Kolom      :", x$summary$outlier_cols_before, "kolom ->",
        x$summary$outlier_cols_after, "kolom (",
        x$summary$outlier_rows_removed, "baris dihapus)\n", sep = "")
    cat("    * Kolom dengan outlier:", x$summary$outlier_cols_names, "\n")

    if (!is.null(x$summary$outlier_details)) {
      cat("    * Detail Outlier:\n")
      for (col in names(x$summary$outlier_details)) {
        det <- x$summary$outlier_details[[col]]
        cat("        -", col, ":", det$n_outliers, "outlier (",
            det$pct_outliers, "%) dari", det$total_values, "data\n", sep = "")
      }
    }
  } else {
    cat("    * Outlier            : Tidak ada outlier terdeteksi\n")
  }

  cat("    * Kualitas Awal Data :", x$summary$health_score, "/ 100 (", x$summary$health_status, ")\n")

  if (!is.null(x$changelog) && nrow(x$changelog) > 1) {
    cat("\n Riwayat Pembersihan (Changelog):\n")
    for (i in 2:nrow(x$changelog)) {
      row <- x$changelog[i, ]
      cat("    [Step ", row$step - 1, "] ", sprintf("%-35s", row$action),
          " Baris: ", row$rows_before, " -> ", row$rows_after, "\n", sep = "")
    }
  }

  if (!is.null(x$validation) && nrow(x$validation) > 0) {
    n_anom <- sum(x$validation$anomaly)
    cat("\n Cross Validation:\n")
    cat("    * Total kombinasi:", nrow(x$validation), "\n")
    cat("    * Anomali ditemukan:", n_anom, "\n")
  }

  cat("\n", rep("=", 70), "\n", sep = "")
  return(invisible(x))
}
