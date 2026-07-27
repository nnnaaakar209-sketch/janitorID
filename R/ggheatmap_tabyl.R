#' Visualisasi Heatmap untuk Objek Tabyl
#'
#' Fungsi ini mengubah objek hasil dari \code{janitor::tabyl()} yang berupa tabulasi silang (dua arah)
#' menjadi visualisasi heatmap yang informatif menggunakan \code{ggplot2}.
#'
#' @param dat Objek berupa data frame dengan kelas \code{tabyl} hasil dari tabulasi dua arah.
#' @param fill_palette Karakter teks menentukan palet warna Brewer yang digunakan (contoh: "YlOrRd", "Blues", "Purples"). Default adalah "YlOrRd".
#' @param show_values Logis (TRUE/FALSE), menentukan apakah angka frekuensi/nilai akan ditampilkan di dalam kotak heatmap. Default adalah TRUE.
#'
#' @return Sebuah objek grafik \code{ggplot}.
#' @export
#'
#' @import ggplot2
#' @importFrom tidyr pivot_longer
#' @importFrom dplyr .data
#' @importFrom janitor tabyl
#'
#' @examples
#' \dontrun{
#' library(janitor)
#' # Membuat data contoh
#' data_contoh <- data.frame(
#'   Kecamatan = rep(c("Bogor Barat", "Bogor Timur", "Bogor Tengah"), each = 10),
#'   Status = sample(c("Lunas", "Gagal", "Tertunda"), 30, replace = TRUE)
#' )
#'
#' # Membuat tabyl dua arah
#' tabel_silang <- tabyl(data_contoh, Kecamatan, Status)
#'
#' # Visualisasi dengan ggheatmap_tabyl
#' ggheatmap_tabyl(tabel_silang, fill_palette = "Blues")
#' }
ggheatmap_tabyl <- function(dat, fill_palette = "YlOrRd", show_values = TRUE) {

  # 1. Proteksi Input / Defensive Programming
  if (!inherits(dat, "tabyl")) {
    stop("Input 'dat' harus berupa objek hasil dari fungsi tabyl() janitor.")
  }
  if (ncol(dat) < 3) {
    stop("Fungsi ini membutuhkan objek tabyl hasil tabulasi silang dua arah (minimal 3 kolom termasuk nama baris).")
  }

  # 2. Ekstraksi Informasi Variabel
  y_var <- names(dat)[1]

  # 3. Restrukturisasi Data (Wide to Long)
  dat_long <- tidyr::pivot_longer(
    dat,
    cols = -1,
    names_to = "Variabel_Kolom",
    values_to = "Nilai"
  )

  # 4. Membangun Base Grafik dengan ggplot2
  p <- ggplot2::ggplot(dat_long, ggplot2::aes(x = .data$Variabel_Kolom, y = .data[[y_var]], fill = .data$Nilai)) +
    ggplot2::geom_tile(color = "white", lwd = 0.5) +
    ggplot2::scale_fill_distiller(palette = fill_palette, direction = 1) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 45, hjust = 1),
      panel.grid = ggplot2::element_blank()
    ) +
    ggplot2::labs(
      title = paste("Heatmap Tabulasi Silang:", y_var, "vs Kategori Kolom"),
      x = "Kategori Kolom",
      y = y_var,
      fill = "Jumlah"
    )

  # 5. Opsi Menampilkan Angka di Dalam Kotak
  if (show_values) {
    p <- p + ggplot2::geom_text(ggplot2::aes(label = round(.data$Nilai, 2)), color = "black", size = 3.5)
  }

  return(p)
}
