#' Dashboard Kesehatan Data Interaktif Lengkap
#'
#' Fungsi ini menghasilkan dashboard komprehensif untuk mengecek kesehatan data:
#' - Pola missing values
#' - Deteksi outlier
#' - Heatmap korelasi
#' - Distribusi numerik & kategorik
#' - Ringkasan data
#'
#' @param data Data frame yang akan dianalisis
#' @param interactive Boolean, jika TRUE menggunakan plotly (interaktif)
#' @param show_outliers Boolean, menampilkan plot outlier
#' @param show_correlation Boolean, menampilkan heatmap korelasi
#' @param show_missing Boolean, menampilkan pola data hilang
#' @param show_distribution Boolean, menampilkan grafik distribusi
#' @param show_summary Boolean, menampilkan summary cards
#' @param title Karakter, judul utama dashboard
#' @param max_cols Integer, batas maksimal kolom yang diproses
#' @param palette Karakter, pilihan warna ("default", "colorblind", "vibrant")
#' @param is_cleaned Boolean, jika TRUE grafik outlier dipaksa 0%
#'
#' @return Objek ggplot atau plotly
#' @export
plot_data_health <- function(
    data,
    interactive = FALSE,
    show_outliers = TRUE,
    show_correlation = TRUE,
    show_missing = TRUE,
    show_distribution = TRUE,
    show_summary = TRUE,
    title = NULL,
    max_cols = 15,
    palette = "default",
    is_cleaned = FALSE
) {

  # --- VALIDASI ---
  if (!is.data.frame(data)) {
    stop("Parameter 'data' harus berupa data frame.")
  }

  if (nrow(data) == 0 || ncol(data) == 0) {
    p_empty <- ggplot2::ggplot() +
      ggplot2::annotate("text", x = 0.5, y = 0.5, label = "Data frame kosong") +
      ggplot2::theme_void()
    return(p_empty)
  }

  if (ncol(data) > max_cols) {
    warning("Data memiliki ", ncol(data), " kolom. Hanya ", max_cols,
            " kolom pertama yang akan ditampilkan.")
    data <- data[, 1:max_cols, drop = FALSE]
  }

  if (is.null(title)) {
    data_name <- deparse(substitute(data))
    title <- paste0("Dashboard Kesehatan Data: ", data_name)
  }

  # --- PALET WARNA ---
  colors_map <- switch(
    palette,
    "colorblind" = list(ok = "#0072B2", alert = "#D55E00", fill_bars = "#56B4E9"),
    "vibrant"    = list(ok = "#2ECC71", alert = "#E74C3C", fill_bars = "#9B59B6"),
    list(ok = "#2ECC71", alert = "#E74C3C", fill_bars = "#3498DB")
  )

  # --- METRIK DASAR ---
  metrics <- list(
    n_rows = nrow(data),
    n_cols = ncol(data),
    n_missing = sum(is.na(data)),
    pct_missing = round(sum(is.na(data)) / (nrow(data) * ncol(data)) * 100, 2),
    n_duplicates = sum(duplicated(data))
  )

  plot_list <- list()

  # ==========================================================================
  # 1. MISSINGNESS MAP
  # ==========================================================================

  if (show_missing) {
    cols_for_missing <- names(data)[1:min(ncol(data), 20)]
    missing_mat <- is.na(data[, cols_for_missing, drop = FALSE])

    missing_df <- expand.grid(
      row_id = 1:nrow(data),
      column = cols_for_missing,
      stringsAsFactors = FALSE
    )
    missing_df$is_missing <- as.vector(missing_mat)

    p_missing <- ggplot2::ggplot(
      missing_df,
      ggplot2::aes(x = column, y = row_id, fill = is_missing)
    ) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_manual(
        values = c("FALSE" = colors_map$ok, "TRUE" = colors_map$alert),
        labels = c("FALSE" = "Ada Data", "TRUE" = "Missing")
      ) +
      ggplot2::labs(
        title = "Pola Missing Values",
        x = "", y = "Baris", fill = "Status"
      ) +
      ggplot2::theme_minimal() +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 8),
        axis.text.y = ggplot2::element_text(size = 7),
        legend.position = "bottom",
        plot.title = ggplot2::element_text(face = "bold", size = 11)
      ) +
      ggplot2::scale_y_reverse()

    plot_list$missing <- p_missing
  }

  # ==========================================================================
  # 2. OUTLIER DETECTION
  # ==========================================================================

  if (show_outliers) {
    numeric_cols <- names(data)[sapply(data, is.numeric)]

    if (length(numeric_cols) > 0) {
      outlier_results <- lapply(numeric_cols, function(col) {
        vals <- data[[col]][!is.na(data[[col]])]

        # Jika data sudah cleaned → langsung 0%
        if (is_cleaned) {
          return(data.frame(
            column = col,
            n_outliers = 0,
            pct_outliers = 0,
            stringsAsFactors = FALSE
          ))
        }

        # Hitung outlier (IQR method)
        if (length(vals) > 3) {
          Q1 <- stats::quantile(vals, 0.25)
          Q3 <- stats::quantile(vals, 0.75)
          IQR_val <- Q3 - Q1
          if (IQR_val > 0) {
            n_out <- sum(vals < (Q1 - 1.5 * IQR_val) | vals > (Q3 + 1.5 * IQR_val))
            return(data.frame(
              column = col,
              n_outliers = n_out,
              pct_outliers = round(n_out / length(vals) * 100, 2),
              stringsAsFactors = FALSE
            ))
          }
        }
        return(data.frame(column = col, n_outliers = 0, pct_outliers = 0, stringsAsFactors = FALSE))
      })

      outlier_df <- do.call(rbind, outlier_results)

      if (!is.null(outlier_df) && nrow(outlier_df) > 0 && max(outlier_df$pct_outliers) > 0) {
        p_outliers <- ggplot2::ggplot(
          outlier_df,
          ggplot2::aes(
            x = stats::reorder(column, -pct_outliers),
            y = pct_outliers,
            fill = pct_outliers > 5
          )
        ) +
          ggplot2::geom_bar(stat = "identity") +
          ggplot2::scale_fill_manual(
            values = c("TRUE" = colors_map$alert, "FALSE" = colors_map$fill_bars),
            labels = c("TRUE" = "> 5%", "FALSE" = "<= 5%")
          ) +
          ggplot2::labs(
            title = "Persentase Outlier per Kolom",
            x = "", y = "Outlier (%)", fill = "Kategori"
          ) +
          ggplot2::theme_minimal() +
          ggplot2::theme(
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 8),
            legend.position = "bottom",
            plot.title = ggplot2::element_text(face = "bold", size = 11)
          ) +
          ggplot2::geom_hline(yintercept = 5, linetype = "dashed", color = "red", alpha = 0.5) +
          ggplot2::ylim(0, max(max(outlier_df$pct_outliers, na.rm = TRUE) + 5, 10))

        plot_list$outliers <- p_outliers
      } else {
        plot_list$outliers <- ggplot2::ggplot() +
          ggplot2::annotate("text", x = 0.5, y = 0.5, label = "✅ Tidak ada outlier terdeteksi") +
          ggplot2::theme_void()
      }
    } else {
      plot_list$outliers <- ggplot2::ggplot() +
        ggplot2::annotate("text", x = 0.5, y = 0.5, label = "Tidak ada kolom numerik") +
        ggplot2::theme_void()
    }
  }

  # ==========================================================================
  # 3. HEATMAP KORELASI
  # ==========================================================================

  if (show_correlation) {
    numeric_data <- data[, sapply(data, is.numeric), drop = FALSE]

    if (ncol(numeric_data) >= 2) {
      valid_cols <- sapply(numeric_data, function(x) sum(!is.na(x)) > 1)
      if (sum(valid_cols) >= 2) {
        numeric_data <- numeric_data[, valid_cols, drop = FALSE]
        cor_matrix <- stats::cor(numeric_data, use = "pairwise.complete.obs")

        cor_df <- as.data.frame(as.table(cor_matrix))
        names(cor_df) <- c("Var1", "Var2", "Correlation")

        p_correlation <- ggplot2::ggplot(
          cor_df,
          ggplot2::aes(x = Var1, y = Var2, fill = Correlation)
        ) +
          ggplot2::geom_tile() +
          ggplot2::scale_fill_gradient2(
            low = colors_map$alert,
            mid = "white",
            high = colors_map$ok,
            midpoint = 0,
            limits = c(-1, 1)
          ) +
          ggplot2::labs(title = "Heatmap Korelasi", x = "", y = "", fill = "r") +
          ggplot2::theme_minimal() +
          ggplot2::theme(
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 8),
            axis.text.y = ggplot2::element_text(size = 8),
            plot.title = ggplot2::element_text(face = "bold", size = 11)
          ) +
          ggplot2::coord_fixed()

        plot_list$correlation <- p_correlation
      }
    }

    if (is.null(plot_list$correlation)) {
      plot_list$correlation <- ggplot2::ggplot() +
        ggplot2::annotate("text", x = 0.5, y = 0.5, label = "Minimal 2 kolom numerik valid") +
        ggplot2::theme_void()
    }
  }

  # ==========================================================================
  # 4. DISTRIBUSI NUMERIK
  # ==========================================================================

  if (show_distribution) {
    numeric_cols <- names(data)[sapply(data, is.numeric)]

    if (length(numeric_cols) > 0) {
      num_cols_plot <- numeric_cols[1:min(length(numeric_cols), 6)]

      dist_data <- lapply(num_cols_plot, function(col) {
        vals <- data[[col]][!is.na(data[[col]])]
        if (length(vals) > 0) {
          return(data.frame(column = col, value = vals, stringsAsFactors = FALSE))
        }
        return(NULL)
      })

      dist_df <- do.call(rbind, dist_data)

      if (!is.null(dist_df) && nrow(dist_df) > 0) {
        plot_list$dist_numeric <- ggplot2::ggplot(dist_df, ggplot2::aes(x = value)) +
          ggplot2::geom_histogram(
            bins = 20, fill = colors_map$fill_bars,
            alpha = 0.7, color = "white"
          ) +
          ggplot2::facet_wrap(~column, scales = "free") +
          ggplot2::labs(title = "Distribusi Numerik", x = "Nilai", y = "Freq") +
          ggplot2::theme_minimal() +
          ggplot2::theme(
            strip.text = ggplot2::element_text(face = "bold", size = 8),
            plot.title = ggplot2::element_text(face = "bold", size = 11)
          )
      }
    }

    if (is.null(plot_list$dist_numeric)) {
      plot_list$dist_numeric <- ggplot2::ggplot() +
        ggplot2::annotate("text", x = 0.5, y = 0.5, label = "Tidak ada kolom numerik") +
        ggplot2::theme_void()
    }
  }

  # ==========================================================================
  # 5. DISTRIBUSI KATEGORIK
  # ==========================================================================

  if (show_distribution) {
    cat_cols <- names(data)[sapply(data, function(x) is.factor(x) || is.character(x))]

    if (length(cat_cols) > 0) {
      cat_cols_plot <- cat_cols[1:min(length(cat_cols), 6)]

      cat_data <- lapply(cat_cols_plot, function(col) {
        vals <- data[[col]][!is.na(data[[col]])]
        if (length(vals) > 0) {
          tab <- table(vals)
          df <- data.frame(column = col, value = names(tab), count = as.numeric(tab))
          df <- df[order(-df$count), ]
          return(head(df, 10))
        }
        return(NULL)
      })

      cat_df <- do.call(rbind, cat_data)

      if (!is.null(cat_df) && nrow(cat_df) > 0) {
        plot_list$dist_categorical <- ggplot2::ggplot(
          cat_df,
          ggplot2::aes(x = value, y = count, fill = column)
        ) +
          ggplot2::geom_bar(stat = "identity") +
          ggplot2::facet_wrap(~column, scales = "free") +
          ggplot2::labs(title = "Distribusi Kategorik", x = "", y = "Freq") +
          ggplot2::theme_minimal() +
          ggplot2::theme(
            strip.text = ggplot2::element_text(face = "bold", size = 8),
            axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 10),
            plot.title = ggplot2::element_text(face = "bold", size = 11),
            legend.position = "none"
          )
      }
    }

    if (is.null(plot_list$dist_categorical)) {
      plot_list$dist_categorical <- ggplot2::ggplot() +
        ggplot2::annotate("text", x = 0.5, y = 0.5, label = "Tidak ada kolom kategorik") +
        ggplot2::theme_void()
    }
  }

  # ==========================================================================
  # 6. SUMMARY CARDS
  # ==========================================================================

  if (show_summary) {
    summary_cards <- data.frame(
      x = c(1, 2, 1, 2),
      y = c(2, 2, 1, 1),
      label = c("Total Baris", "Total Kolom", "Missing Values", "Duplikat"),
      value = c(
        format(metrics$n_rows, big.mark = ","),
        metrics$n_cols,
        paste0(metrics$n_missing, " (", metrics$pct_missing, "%)"),
        metrics$n_duplicates
      )
    )

    plot_list$summary <- ggplot2::ggplot(summary_cards, ggplot2::aes(x = x, y = y)) +
      ggplot2::geom_tile(width = 0.88, height = 0.78, fill = "#F8F9FA", color = "#BDC3C7", linewidth = 0.8) +
      ggplot2::geom_text(ggplot2::aes(label = value), vjust = -0.1, size = 4.5, fontface = "bold", color = "#2C3E50") +
      ggplot2::geom_text(ggplot2::aes(label = label), vjust = 1.6, size = 3, color = "#7F8C8D") +
      ggplot2::scale_x_continuous(limits = c(0.4, 2.6)) +
      ggplot2::scale_y_continuous(limits = c(0.4, 2.6)) +
      ggplot2::theme_void() +
      ggplot2::labs(title = "Ringkasan Data") +
      ggplot2::theme(plot.title = ggplot2::element_text(face = "bold", size = 11, hjust = 0.5))
  }

  # ==========================================================================
  # 7. OUTPUT
  # ==========================================================================

  if (length(plot_list) == 0) {
    return(ggplot2::ggplot() +
             ggplot2::annotate("text", x = 0.5, y = 0.5, label = "Tidak ada plot yang dipilih") +
             ggplot2::theme_void())
  }

  # INTERAKTIF (plotly)
  if (interactive && requireNamespace("plotly", quietly = TRUE)) {
    plotly_list <- lapply(plot_list, function(p) {
      tryCatch(plotly::ggplotly(p), error = function(e) p)
    })

    res_plotly <- plotly::subplot(
      plotly_list,
      nrows = ceiling(length(plotly_list) / 2),
      margin = 0.06,
      titleX = TRUE, titleY = TRUE
    ) %>%
      plotly::layout(
        title = list(text = title, font = list(size = 16)),
        margin = list(t = 60, b = 40, l = 40, r = 40)
      ) %>%
      plotly::config(displayModeBar = TRUE, modeBarButtonsToRemove = c("lasso2d", "select2d"))

    return(res_plotly)
  }

  # STATIS (patchwork)
  if (requireNamespace("patchwork", quietly = TRUE)) {
    plot_list <- lapply(plot_list, function(p) {
      p + ggplot2::theme(plot.margin = ggplot2::margin(6, 6, 6, 6))
    })

    combined <- patchwork::wrap_plots(plot_list, ncol = 2) +
      patchwork::plot_annotation(
        title = title,
        subtitle = paste0(
          "Data: ", metrics$n_rows, " baris x ", metrics$n_cols, " kolom | ",
          "Missing: ", metrics$pct_missing, "% | ",
          "Duplikat: ", metrics$n_duplicates
        ),
        theme = ggplot2::theme(
          plot.title = ggplot2::element_text(size = 14, face = "bold", hjust = 0.5),
          plot.subtitle = ggplot2::element_text(size = 10, hjust = 0.5, color = "gray40")
        )
      )
    return(combined)
  } else {
    return(gridExtra::grid.arrange(grobs = plot_list, ncol = 2))
  }
}
