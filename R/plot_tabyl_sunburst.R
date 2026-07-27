#' Visualisasi Sunburst Chart Universal untuk Semua Jenis Data
#'
#' Fungsi ini mengubah objek hasil \code{janitor::tabyl()} dua arah menjadi grafik
#' Sunburst bertingkat. Fungsi ini dirancang kokoh (robust) sehingga otomatis bisa
#' menangani data numerik maupun kategorik tanpa memicu error tipe skala.
#'
#' Fitur:
#' \itemize{
#'   \item Menangani data numerik dan kategorik secara otomatis
#'   \item Warna otomatis dengan palet Dark2
#'   \item Label di setiap level (dalam dan luar)
#'   \item Sistem koordinat polar untuk efek sunburst
#' }
#'
#' @param dat Objek berupa data frame dengan kelas \code{tabyl} hasil dari tabulasi dua arah.
#' @param show_percent Logical, tampilkan persentase di label (default: TRUE)
#' @param palette Character, palet warna dari RColorBrewer (default: "Dark2")
#' @param title Character, judul kustom (optional)
#'
#' @return Sebuah objek grafik \code{ggplot}.
#' @export
#'
#' @import ggplot2
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr group_by mutate ungroup arrange filter .data summarise
#' @importFrom RColorBrewer brewer.pal
#'
#' @examples
#' \dontrun{
#' library(janitor)
#'
#' # Contoh dengan data mtcars
#' tabel_mtcars <- tabyl(mtcars, cyl, gear)
#' plot_tabyl_sunburst_v2(tabel_mtcars)
#'
#' # Contoh dengan data iris
#' tabel_iris <- tabyl(iris, Species, Sepal.Length)
#' plot_tabyl_sunburst_v2(tabel_iris, palette = "Set3")
#' }
plot_tabyl_sunburst_v2 <- function(
    dat,
    show_percent = TRUE,
    palette = "Dark2",
    title = NULL
) {

  # ==========================================================================
  # 1. PROTEKSI INPUT
  # ==========================================================================

  if (!inherits(dat, "tabyl")) {
    stop("Input 'dat' harus berupa objek hasil dari fungsi tabyl() janitor.")
  }
  if (ncol(dat) < 3) {
    stop("Fungsi ini membutuhkan objek tabyl hasil tabulasi silang dua arah (minimal 3 kolom).")
  }

  var_dalam <- names(dat)[1]
  total_keseluruhan <- sum(rowSums(dat[, -1]))

  # ==========================================================================
  # 2. TRANSFORMASI DATA
  # ==========================================================================

  dat_long <- tidyr::pivot_longer(
    dat,
    cols = -1,
    names_to = "var_luar",
    values_to = "Nilai"
  )

  # Paksa menjadi faktor
  dat_long[[var_dalam]] <- as.factor(dat_long[[var_dalam]])
  dat_long$var_luar <- as.factor(dat_long$var_luar)

  # ==========================================================================
  # 3. KALKULASI POSISI LABEL
  # ==========================================================================

  dat_plot <- dat_long %>%
    dplyr::filter(.data$Nilai > 0) %>%
    dplyr::group_by(.data[[var_dalam]]) %>%
    dplyr::mutate(
      Total_Dalam = sum(.data$Nilai),
      Persen_Dalam = .data$Nilai / .data$Total_Dalam * 100,
      Persen_Total = .data$Nilai / total_keseluruhan * 100
    ) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(.data[[var_dalam]], .data$var_luar)

  # Posisi label luar
  dat_plot <- dat_plot %>%
    dplyr::group_by(.data[[var_dalam]]) %>%
    dplyr::mutate(
      pos_y = cumsum(.data$Nilai) - (.data$Nilai / 2)
    ) %>%
    dplyr::ungroup()

  # Label luar (dengan persentase jika diminta)
  if (show_percent) {
    dat_plot$label_luar <- sprintf("%s\n%.1f%%", dat_plot$var_luar, dat_plot$Persen_Dalam)
  } else {
    dat_plot$label_luar <- as.character(dat_plot$var_luar)
  }

  # Label dalam
  dat_dalam_label <- dat_plot %>%
    dplyr::group_by(.data[[var_dalam]]) %>%
    dplyr::summarise(
      Total = unique(.data$Total_Dalam),
      Persen_Total = unique(.data$Total_Dalam) / total_keseluruhan * 100,
      .groups = "drop"
    )

  dat_dalam_label$pos_y <- cumsum(dat_dalam_label$Total) - (dat_dalam_label$Total / 2)

  if (show_percent) {
    dat_dalam_label$label_dalam <- sprintf("%s\n%.1f%%",
                                           dat_dalam_label[[var_dalam]],
                                           dat_dalam_label$Persen_Total)
  } else {
    dat_dalam_label$label_dalam <- as.character(dat_dalam_label[[var_dalam]])
  }

  # ==========================================================================
  # 4. WARNA
  # ==========================================================================

  n_cat <- length(unique(dat_plot[[var_dalam]]))
  warna <- RColorBrewer::brewer.pal(max(3, n_cat), palette)

  # ==========================================================================
  # 5. JUDUL
  # ==========================================================================

  if (is.null(title)) {
    title <- sprintf("☀️ Sunburst Chart: %s vs Kategori", var_dalam)
  }

  # ==========================================================================
  # 6. GRAFIK
  # ==========================================================================

  p <- ggplot2::ggplot() +
    # Cincin Dalam
    ggplot2::geom_bar(
      data = dat_plot,
      ggplot2::aes(x = 1.5, y = .data$Nilai, fill = .data[[var_dalam]]),
      stat = "identity",
      color = "white",
      linewidth = 0.8,
      width = 1,
      show.legend = TRUE
    ) +
    # Cincin Luar
    ggplot2::geom_bar(
      data = dat_plot,
      ggplot2::aes(x = 2.5, y = .data$Nilai, fill = .data[[var_dalam]], alpha = .data$var_luar),
      stat = "identity",
      color = "white",
      linewidth = 0.5,
      width = 1,
      show.legend = FALSE
    ) +
    # Label Dalam
    ggplot2::geom_text(
      data = dat_dalam_label,
      ggplot2::aes(x = 1.5, y = .data$pos_y, label = .data$label_dalam),
      color = "white",
      fontface = "bold",
      size = 4.5
    ) +
    # Label Luar (hanya untuk nilai > 5% agar tidak tumpang tindih)
    ggplot2::geom_text(
      data = dat_plot %>% dplyr::filter(.data$Persen_Dalam > 3),
      ggplot2::aes(x = 2.5, y = .data$pos_y, label = .data$label_luar),
      color = "black",
      size = 3,
      fontface = "bold"
    ) +
    # Label luar kecil untuk nilai kecil
    ggplot2::geom_text(
      data = dat_plot %>% dplyr::filter(.data$Persen_Dalam <= 3 & .data$Persen_Dalam > 0),
      ggplot2::aes(x = 2.5, y = .data$pos_y, label = .data$var_luar),
      color = "gray50",
      size = 2.5
    ) +
    # Koordinat Polar
    ggplot2::coord_polar(theta = "y") +
    ggplot2::xlim(0.3, 3.5) +
    # Warna
    ggplot2::scale_fill_manual(values = warna, name = var_dalam) +
    ggplot2::scale_alpha_discrete(range = c(0.4, 0.9)) +
    # Theme
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(
        face = "bold",
        hjust = 0.5,
        size = 18,
        color = "#2c3e50",
        margin = ggplot2::margin(b = 8)
      ),
      plot.subtitle = ggplot2::element_text(
        hjust = 0.5,
        size = 11,
        color = "#7f8c8d",
        margin = ggplot2::margin(b = 15)
      ),
      legend.position = "right",
      legend.title = ggplot2::element_text(
        face = "bold",
        size = 11
      ),
      legend.text = ggplot2::element_text(size = 10),
      legend.key.size = ggplot2::unit(0.8, "cm"),
      plot.background = ggplot2::element_rect(
        fill = "white",
        color = NA
      ),
      panel.background = ggplot2::element_rect(
        fill = "white",
        color = NA
      )
    ) +
    ggplot2::labs(
      title = title,
      subtitle = sprintf(
        "Total: %d observasi | %s: %d kategori | Kategori Luar: %d kategori",
        total_keseluruhan,
        var_dalam,
        length(unique(dat_plot[[var_dalam]])),
        length(unique(dat_plot$var_luar))
      ),
      fill = var_dalam
    )

  return(p)
}
