#' Plot Kesehatan Data untuk Presentasi (Versi Besar)
#'
#' Fungsi ini menghasilkan visualisasi spesifik untuk presentasi:
#' - Missing values pattern
#' - Correlation heatmap
#' - Outlier percentage per column
#' - Distribution of numeric columns
#'
#' @param data Data frame yang akan dianalisis.
#' @param type Tipe visualisasi: `"missing"`, `"correlation"`, `"outlier"`,
#'   atau `"distribution"`. Default adalah `"missing"`.
#' @param is_cleaned Boolean, jika TRUE grafik outlier dipaksa 0%.
#'
#' @return Objek \code{ggplot} yang divisualisasikan.
#'
#' @import ggplot2
#' @importFrom stats cor quantile reorder
#' @export
plot_health_presentation <- function(
    data,
    type = c("missing", "correlation", "outlier", "distribution"),
    is_cleaned = FALSE
) {

  type <- match.arg(type)

  # ==========================================================================
  # 1. MISSING VALUES PATTERN
  # ==========================================================================

  if (type == "missing") {
    missing_df <- data.frame(
      row_id = rep(1:nrow(data), ncol(data)),
      column = rep(names(data), each = nrow(data)),
      is_missing = as.vector(sapply(data, is.na))
    )

    p <- ggplot2::ggplot(missing_df, ggplot2::aes(x = column, y = row_id, fill = is_missing)) +
      ggplot2::geom_tile() +
      ggplot2::scale_fill_manual(
        values = c("FALSE" = "#2ECC71", "TRUE" = "#E74C3C"),
        labels = c("FALSE" = "Ada Data", "TRUE" = "Missing")
      ) +
      ggplot2::labs(
        title = paste("Pola Missing Values -", deparse(substitute(data))),
        x = "Kolom",
        y = "Baris"
      ) +
      ggplot2::theme_minimal(base_size = 14) +
      ggplot2::theme(
        axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 12),
        axis.text.y = ggplot2::element_text(size = 8),
        legend.position = "bottom",
        plot.title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5)
      ) +
      ggplot2::scale_y_continuous(trans = "reverse")

    return(p)

    # ==========================================================================
    # 2. CORRELATION HEATMAP
    # ==========================================================================

  } else if (type == "correlation") {
    numeric_data <- data[, sapply(data, is.numeric), drop = FALSE]

    if (ncol(numeric_data) >= 2) {
      cor_matrix <- stats::cor(numeric_data, use = "pairwise.complete.obs")
      cor_df <- as.data.frame(as.table(cor_matrix))
      names(cor_df) <- c("Var1", "Var2", "Correlation")
      cor_df <- cor_df[cor_df$Var1 != cor_df$Var2, ]

      p <- ggplot2::ggplot(cor_df, ggplot2::aes(x = Var1, y = Var2, fill = Correlation)) +
        ggplot2::geom_tile() +
        ggplot2::geom_text(ggplot2::aes(label = round(Correlation, 2)), size = 3) +
        ggplot2::scale_fill_gradient2(
          low = "#E74C3C",
          mid = "white",
          high = "#2ECC71",
          midpoint = 0,
          limits = c(-1, 1)
        ) +
        ggplot2::labs(
          title = paste("Heatmap Korelasi -", deparse(substitute(data))),
          x = "", y = "", fill = "Korelasi"
        ) +
        ggplot2::theme_minimal(base_size = 14) +
        ggplot2::theme(
          axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 12),
          axis.text.y = ggplot2::element_text(size = 12),
          plot.title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5)
        ) +
        ggplot2::coord_fixed()

      return(p)
    } else {
      return(ggplot2::ggplot() +
               ggplot2::annotate("text", x = 0.5, y = 0.5,
                                 label = "Minimal 2 kolom numerik untuk korelasi", size = 5) +
               ggplot2::theme_void())
    }

    # ==========================================================================
    # 3. OUTLIER DETECTION
    # ==========================================================================

  } else if (type == "outlier") {

    # Jika data sudah cleaned → langsung 0%
    if (is_cleaned) {
      p <- ggplot2::ggplot() +
        ggplot2::annotate("text", x = 0.5, y = 0.5,
                          label = "✅ Tidak ada outlier (data sudah dibersihkan)",
                          size = 6, color = "#2ECC71") +
        ggplot2::theme_void() +
        ggplot2::labs(
          title = paste("Persentase Outlier -", deparse(substitute(data))),
          subtitle = "Semua outlier telah dihapus oleh auto_cleaner"
        ) +
        ggplot2::theme(
          plot.title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5),
          plot.subtitle = ggplot2::element_text(size = 12, hjust = 0.5, color = "gray50")
        )
      return(p)
    }

    # Hitung outlier (IQR method)
    numeric_cols <- names(data)[sapply(data, is.numeric)]

    if (length(numeric_cols) == 0) {
      return(ggplot2::ggplot() +
               ggplot2::annotate("text", x = 0.5, y = 0.5,
                                 label = "Tidak ada kolom numerik", size = 5) +
               ggplot2::theme_void())
    }

    outlier_df <- data.frame(column = character(), pct_outliers = numeric())

    for (col in numeric_cols) {
      vals <- data[[col]][!is.na(data[[col]])]
      if (length(vals) > 3) {
        Q1 <- stats::quantile(vals, 0.25, na.rm = TRUE)
        Q3 <- stats::quantile(vals, 0.75, na.rm = TRUE)
        IQR <- Q3 - Q1
        if (IQR > 0) {
          n_out <- sum(vals < (Q1 - 1.5 * IQR) | vals > (Q3 + 1.5 * IQR))
          if (n_out > 0) {
            outlier_df <- rbind(outlier_df, data.frame(
              column = col,
              pct_outliers = round(n_out / length(vals) * 100, 2)
            ))
          }
        }
      }
    }

    if (nrow(outlier_df) > 0 && max(outlier_df$pct_outliers) > 0) {
      p <- ggplot2::ggplot(
        outlier_df,
        ggplot2::aes(
          x = stats::reorder(column, -pct_outliers),
          y = pct_outliers,
          fill = pct_outliers > 5
        )
      ) +
        ggplot2::geom_bar(stat = "identity") +
        ggplot2::scale_fill_manual(
          values = c("TRUE" = "#E74C3C", "FALSE" = "#3498DB"),
          labels = c("TRUE" = "Outlier Tinggi", "FALSE" = "Normal")
        ) +
        ggplot2::labs(
          title = paste("Persentase Outlier -", deparse(substitute(data))),
          x = "Kolom Numerik",
          y = "Persentase Outlier (%)"
        ) +
        ggplot2::theme_minimal(base_size = 14) +
        ggplot2::theme(
          axis.text.x = ggplot2::element_text(angle = 45, hjust = 1, size = 12),
          legend.position = "bottom",
          plot.title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5)
        ) +
        ggplot2::geom_hline(yintercept = 5, linetype = "dashed", color = "red", alpha = 0.5)

      return(p)
    } else {
      return(
        ggplot2::ggplot() +
          ggplot2::annotate("text", x = 0.5, y = 0.5,
                            label = "✅ Tidak ada outlier terdeteksi", size = 6, color = "#2ECC71") +
          ggplot2::theme_void()
      )
    }

    # ==========================================================================
    # 4. DISTRIBUTION
    # ==========================================================================

  } else {
    numeric_cols <- names(data)[sapply(data, is.numeric)]
    num_cols_plot <- numeric_cols[1:min(length(numeric_cols), 4)]

    if (length(num_cols_plot) == 0) {
      return(ggplot2::ggplot() +
               ggplot2::annotate("text", x = 0.5, y = 0.5,
                                 label = "Tidak ada kolom numerik", size = 5) +
               ggplot2::theme_void())
    }

    dist_data <- list()
    for (col in num_cols_plot) {
      vals <- data[[col]][!is.na(data[[col]])]
      if (length(vals) > 0) {
        dist_data[[col]] <- data.frame(column = col, value = vals)
      }
    }

    if (length(dist_data) > 0) {
      dist_df <- do.call(rbind, dist_data)

      p <- ggplot2::ggplot(dist_df, ggplot2::aes(x = value)) +
        ggplot2::geom_histogram(bins = 20, fill = "#3498DB", alpha = 0.7, color = "white") +
        ggplot2::facet_wrap(~column, scales = "free") +
        ggplot2::labs(
          title = paste("Distribusi Kolom Numerik -", deparse(substitute(data))),
          x = "Nilai",
          y = "Frekuensi"
        ) +
        ggplot2::theme_minimal(base_size = 14) +
        ggplot2::theme(
          strip.text = ggplot2::element_text(face = "bold", size = 12),
          plot.title = ggplot2::element_text(size = 18, face = "bold", hjust = 0.5)
        )

      return(p)
    } else {
      return(
        ggplot2::ggplot() +
          ggplot2::annotate("text", x = 0.5, y = 0.5,
                            label = "Tidak ada kolom numerik", size = 5) +
          ggplot2::theme_void()
      )
    }
  }
}
