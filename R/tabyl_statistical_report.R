#' Generator Laporan Statistik Inferensial Universal dari Objek Tabyl
#'
#' Fungsi ini menghasilkan laporan statistik inferensial lengkap dari objek tabyl
#' dua arah, mencakup:
#' \itemize{
#'   \item Matriks Frekuensi Aktual (Observed)
#'   \item Matriks Nilai Harapan (Expected)
#'   \item Uji Hipotesis Chi-Square + Effect Size (Cramer's V)
#'   \item Uji Asumsi Kelayakan (Cochran's Criteria)
#'   \item Bonus Odds Ratio untuk tabel 2x2
#' }
#'
#' Fitur interaktif dengan menu looping sehingga user bisa memilih bagian
#' yang ingin dilihat tanpa harus menjalankan ulang fungsi.
#'
#' @param dat Objek berupa data frame dengan kelas \code{tabyl} hasil dari tabulasi dua arah.
#' @param title Character, judul laporan statistik utama (default: "LAPORAN STATISTIK INFERENSIAL UNIVERSAL")
#' @param alpha Numeric, tingkat signifikansi (default: 0.05)
#' @param language Character, bahasa output ("id" untuk Indonesia, "en" untuk English) (default: "id")
#'
#' @return Tidak ada return value, fungsi ini mencetak laporan ke console secara interaktif.
#' @export
#'
#' @importFrom stats chisq.test
#'
#' @examples
#' \dontrun{
#' library(janitor)
#'
#' # Contoh dengan data mtcars
#' tabel_mtcars <- tabyl(mtcars, cyl, gear)
#' tabyl_to_statistical_report_console(tabel_mtcars)
#'
#' # Contoh dengan data iris
#' tabel_iris <- tabyl(iris, Species, Sepal.Length)
#' tabyl_to_statistical_report_console(tabel_iris, title = "Analisis Iris")
#'
#' # Contoh bahasa Inggris
#' tabyl_to_statistical_report_console(tabel_mtcars, language = "en")
#' }
tabyl_to_statistical_report_console <- function(
    dat,
    title = "LAPORAN STATISTIK INFERENSIAL UNIVERSAL",
    alpha = 0.05,
    language = "id"
) {

  # ==========================================================================
  # 1. VALIDASI INPUT
  # ==========================================================================

  if (!inherits(dat, "tabyl")) {
    stop("Input harus berupa objek hasil dari fungsi tabyl() janitor.")
  }

  if (ncol(dat) < 3) {
    stop("Fungsi ini membutuhkan objek tabyl dua arah (minimal 3 kolom).")
  }

  # ==========================================================================
  # 2. KALKULASI DASAR
  # ==========================================================================

  matriks_angka <- as.matrix(dat[, -1])
  total_n <- sum(matriks_angka)
  r <- nrow(matriks_angka)
  c <- ncol(matriks_angka)

  var_baris <- names(dat)[1]
  var_kolom <- names(dat)[2]

  # Matriks Nilai Harapan (E)
  matriks_ekspektasi <- (rowSums(matriks_angka) %*% t(colSums(matriks_angka))) / total_n
  dimnames(matriks_ekspektasi) <- list(dat[[1]], colnames(matriks_angka))

  # Uji Chi-Square (dihitung sekali di awal)
  uji_chisq <- chisq.test(matriks_angka, correct = FALSE)
  k_min <- min(r - 1, c - 1)
  cramer_v <- sqrt(as.numeric(uji_chisq$statistic) / (total_n * k_min))

  # ==========================================================================
  # 3. FUNGSI PEMBANTU TEXT (Multi-language)
  # ==========================================================================

  text <- function(key) {
    texts <- list(
      id = list(
        menu_title = "\n╔══════════════════════════════════════════════════════════════╗\n║                   MENU UTAMA LAPORAN STATISTIK              ║\n╚══════════════════════════════════════════════════════════════╝\n\nSilakan pilih bagian output yang ingin Anda lihat:",
        menu_choices = c(
          "Matriks Frekuensi Aktual (Observed)",
          "Matriks Nilai Harapan (Expected)",
          "Uji Hipotesis Chi-Square & Effect Size",
          "Uji Asumsi Kelayakan (Cochran's Criteria)",
          "Keluar / Tutup Laporan"
        ),
        exit = "👋 LAPORAN SELESAI!",
        header = "📊",
        section1 = "MATRIKS FREKUENSI AKTUAL (O)",
        section2 = "MATRIKS NILAI HARAPAN (E)",
        section3 = "UJI HIPOTESIS INDEPENDENSI CHI-SQUARE",
        section4 = "UJI ASUMSI KELAYAKAN (Cochran's Criteria)",
        hypothesis_h0 = "H0: %s dan %s saling independen (tidak ada hubungan)",
        hypothesis_h1 = "H1: %s dan %s saling dependen (ada hubungan)",
        interpret_expected = "📌 Interpretasi: Nilai ini dihitung dengan rumus (total baris × total kolom) / total N\n   Jika semua sel E ≥ 5, asumsi Chi-Square terpenuhi.",
        interpret_expected_en = "📌 Interpretation: Values are calculated as (row total × column total) / total N\n   If all cells have E ≥ 5, Chi-Square assumption is met.",
        reject = "🚨 TOLAK H0 (Terdapat hubungan signifikan antar variabel)",
        fail_reject = "🏳️ GAGAL TOLAK H0 (Tidak cukup bukti adanya hubungan)",
        effect_size = "📈 UKURAN EFEK (Cramer's V): %.4f (%s)",
        effect_strong = "Sangat Kuat",
        effect_moderate = "Sedang",
        effect_weak = "Lemah",
        effect_very_weak = "Sangat Lemah",
        bonus_or = "🎯 BONUS: ODDS RATIO (Untuk Tabel 2x2)",
        or_interpret = "Peluang %s pada %s %.2f kali lebih besar",
        or_interpret_less = "Peluang %s pada %s %.2f kali lebih kecil",
        or_no_diff = "Tidak ada perbedaan peluang",
        criteria = "📋 KRITERIA COCHRAN:\n   • Tidak boleh ada sel dengan Expected < 1\n   • Tidak boleh lebih dari 20% sel dengan Expected < 5",
        assumptions_check = "📊 HASIL CEK ASUMSI:",
        total_cells = "Total sel",
        cells_e5 = "Sel dengan E < 5",
        cells_e1 = "Sel dengan E < 1",
        cells_o0 = "Sel dengan O = 0 (aktual)",
        assumption_violation_severe = "❌ PELANGGARAN BERAT: Ada sel dengan Expected < 1. Chi-Square TIDAK valid!",
        assumption_violation = "⚠️ PELANGGARAN ASUMSI: >20%% sel Expected < 5. Chi-Square kurang valid!",
        assumption_met = "✅ ASUMSI TERPENUHI: Data cocok untuk uji Chi-Square.",
        recommendation = "💡 REKOMENDASI:\n   • Gabungkan kategori yang jarang muncul\n   • Gunakan uji Exact Fisher (untuk tabel 2x2)\n   • Tambahkan data / perbesar sampel",
        back_to_menu = "🔄 Kembali ke menu utama...",
        loop_message = "🔄 Laporan bagian selesai dicetak. Kembali ke menu utama...",
        total_n = "Total N: %d | Ukuran Tabel: %d x %d",
        vars = "Variabel Baris: %s | Variabel Kolom: %s",
        chi_square = "Chi-Square Hitung (X²)",
        df = "Derajat Bebas (df)",
        p_value = "Nilai p-value",
        alpha_text = "Tingkat Signifikansi (α)",
        decision = "Keputusan",
        total_obs = "Total: %d observasi"
      ),
      en = list(
        menu_title = "\n╔══════════════════════════════════════════════════════════════╗\n║                STATISTICAL REPORT MAIN MENU                 ║\n╚══════════════════════════════════════════════════════════════╝\n\nPlease select the output section you want to view:",
        menu_choices = c(
          "Observed Frequency Matrix",
          "Expected Frequency Matrix",
          "Chi-Square Hypothesis Test & Effect Size",
          "Assumptions Check (Cochran's Criteria)",
          "Exit / Close Report"
        ),
        exit = "👋 REPORT COMPLETED!",
        header = "📊",
        section1 = "OBSERVED FREQUENCY MATRIX (O)",
        section2 = "EXPECTED FREQUENCY MATRIX (E)",
        section3 = "CHI-SQUARE INDEPENDENCE TEST",
        section4 = "ASSUMPTIONS CHECK (Cochran's Criteria)",
        hypothesis_h0 = "H0: %s and %s are independent (no relationship)",
        hypothesis_h1 = "H1: %s and %s are dependent (there is a relationship)",
        interpret_expected = "📌 Interpretation: Values are calculated as (row total × column total) / total N\n   If all cells have E ≥ 5, Chi-Square assumption is met.",
        interpret_expected_en = "📌 Interpretation: Values are calculated as (row total × column total) / total N\n   If all cells have E ≥ 5, Chi-Square assumption is met.",
        reject = "🚨 REJECT H0 (There is a significant relationship between variables)",
        fail_reject = "🏳️ FAIL TO REJECT H0 (Insufficient evidence of relationship)",
        effect_size = "📈 EFFECT SIZE (Cramer's V): %.4f (%s)",
        effect_strong = "Very Strong",
        effect_moderate = "Moderate",
        effect_weak = "Weak",
        effect_very_weak = "Very Weak",
        bonus_or = "🎯 BONUS: ODDS RATIO (For 2x2 Table)",
        or_interpret = "Odds of %s in %s is %.2f times higher",
        or_interpret_less = "Odds of %s in %s is %.2f times lower",
        or_no_diff = "No difference in odds",
        criteria = "📋 COCHRAN'S CRITERIA:\n   • No cells with Expected < 1\n   • Less than 20%% of cells with Expected < 5",
        assumptions_check = "📊 ASSUMPTIONS CHECK RESULTS:",
        total_cells = "Total cells",
        cells_e5 = "Cells with E < 5",
        cells_e1 = "Cells with E < 1",
        cells_o0 = "Cells with O = 0 (observed)",
        assumption_violation_severe = "❌ SEVERE VIOLATION: Cells with Expected < 1. Chi-Square is NOT valid!",
        assumption_violation = "⚠️ ASSUMPTION VIOLATION: >20%% cells with Expected < 5. Chi-Square may be invalid!",
        assumption_met = "✅ ASSUMPTIONS MET: Data is suitable for Chi-Square test.",
        recommendation = "💡 RECOMMENDATIONS:\n   • Combine rare categories\n   • Use Fisher's Exact Test (for 2x2 tables)\n   • Collect more data / increase sample size",
        back_to_menu = "🔄 Returning to main menu...",
        loop_message = "🔄 Section printed. Returning to main menu...",
        total_n = "Total N: %d | Table Size: %d x %d",
        vars = "Row Variable: %s | Column Variable: %s",
        chi_square = "Chi-Square Statistic (X²)",
        df = "Degrees of Freedom (df)",
        p_value = "p-value",
        alpha_text = "Significance Level (α)",
        decision = "Decision",
        total_obs = "Total: %d observations"
      )
    )
    return(texts[[language]][[key]])
  }

  # ==========================================================================
  # 4. MENU UTAMA (LOOPING INTERAKTIF)
  # ==========================================================================

  while (TRUE) {

    pilihan <- menu(
      choices = text("menu_choices"),
      graphics = FALSE,
      title = text("menu_title")
    )

    # Kondisi keluar
    if (pilihan == 5 || pilihan == 0) {
      cat("\n╔══════════════════════════════════════════════════════════════╗\n")
      cat(sprintf("║                  %s                ║\n", text("exit")))
      cat("╚══════════════════════════════════════════════════════════════╝\n\n")
      break
    }

    # HEADER UTAMA
    cat("\n", rep("═", 75), "\n", sep = "")
    cat(sprintf("%s %s\n", text("header"), toupper(title)))
    cat(sprintf("   %s\n", sprintf(text("total_n"), total_n, r, c)))
    cat(sprintf("   %s\n", sprintf(text("vars"), var_baris, var_kolom)))
    cat(rep("═", 75), "\n\n", sep = "")

    # ========================================================================
    # PILIHAN 1: MATRIKS FREKUENSI AKTUAL
    # ========================================================================

    if (pilihan == 1) {
      cat(sprintf("[%s]\n", text("section1")))
      cat(rep("─", 75), "\n", sep = "")
      print(dat, row.names = FALSE)
      cat(rep("─", 75), "\n", sep = "")
      cat(sprintf("\n%s\n\n", sprintf(text("total_obs"), total_n)))
    }

    # ========================================================================
    # PILIHAN 2: MATRIKS NILAI HARAPAN
    # ========================================================================

    if (pilihan == 2) {
      cat(sprintf("[%s]\n", text("section2")))
      cat(rep("─", 75), "\n", sep = "")
      print(round(matriks_ekspektasi, 2))
      cat(rep("─", 75), "\n", sep = "")
      cat("\n")
      cat(text("interpret_expected"))
      cat("\n\n")
    }

    # ========================================================================
    # PILIHAN 3: UJI HIPOTESIS
    # ========================================================================

    if (pilihan == 3) {

      cat(sprintf("[%s]\n", text("section3")))
      cat(rep("─", 75), "\n", sep = "")

      # Hipotesis
      cat("\n📌 HIPOTESIS:\n")
      cat(sprintf("   %s\n", sprintf(text("hypothesis_h0"), var_baris, var_kolom)))
      cat(sprintf("   %s\n", sprintf(text("hypothesis_h1"), var_baris, var_kolom)))

      # Hasil Uji
      cat("\n📊 HASIL UJI:\n")
      cat(sprintf("   %s: %.4f\n", text("chi_square"), uji_chisq$statistic))
      cat(sprintf("   %s: %d\n", text("df"), uji_chisq$parameter))
      cat(sprintf("   %s: %.6f\n", text("p_value"), uji_chisq$p.value))

      # Keputusan
      cat(sprintf("   %s: %.2f\n", text("alpha_text"), alpha))
      keputusan_ho <- if (uji_chisq$p.value < alpha) {
        text("reject")
      } else {
        text("fail_reject")
      }
      cat(sprintf("   %s: %s\n", text("decision"), keputusan_ho))

      # Effect Size (Cramer's V)
      status_v <- if(cramer_v >= 0.5) {
        text("effect_strong")
      } else if(cramer_v >= 0.3) {
        text("effect_moderate")
      } else if(cramer_v >= 0.1) {
        text("effect_weak")
      } else {
        text("effect_very_weak")
      }
      cat(sprintf("\n%s\n", sprintf(text("effect_size"), cramer_v, status_v)))
      cat(rep("─", 75), "\n", sep = "")

      # Bonus Odds Ratio untuk tabel 2x2
      if (r == 2 && c == 2) {
        cat(sprintf("\n%s\n", text("bonus_or")))
        a <- matriks_angka[1,1]; b <- matriks_angka[1,2]
        cc <- matriks_angka[2,1]; d <- matriks_angka[2,2]
        odds_ratio <- (a * d) / (b * cc)
        cat(sprintf("   Odds Ratio (OR): %.4f\n", odds_ratio))
        cat("   Interpretasi: ")
        if (odds_ratio > 1) {
          cat(sprintf(text("or_interpret"), colnames(matriks_angka)[1], dat[1,1], odds_ratio))
        } else if (odds_ratio < 1) {
          cat(sprintf(text("or_interpret_less"), colnames(matriks_angka)[1], dat[1,1], 1/odds_ratio))
        } else {
          cat(text("or_no_diff"))
        }
        cat("\n")
        cat(rep("─", 75), "\n", sep = "")
      }
      cat("\n")
    }

    # ========================================================================
    # PILIHAN 4: UJI ASUMSI KELAYAKAN
    # ========================================================================

    if (pilihan == 4) {

      sel_kurang_5 <- sum(matriks_ekspektasi < 5)
      persen_kurang_5 <- (sel_kurang_5 / length(matriks_ekspektasi)) * 100
      sel_nol <- sum(matriks_angka == 0)
      sel_kurang_1 <- sum(matriks_ekspektasi < 1)

      cat(sprintf("[%s]\n", text("section4")))
      cat(rep("─", 75), "\n", sep = "")

      cat("\n")
      cat(text("criteria"))

      cat("\n\n")
      cat(text("assumptions_check"))
      cat("\n")
      cat(sprintf("   %s: %d\n", text("total_cells"), length(matriks_ekspektasi)))
      cat(sprintf("   %s: %d sel (%.2f%%)\n", text("cells_e5"), sel_kurang_5, persen_kurang_5))
      cat(sprintf("   %s: %d sel\n", text("cells_e1"), sel_kurang_1))
      cat(sprintf("   %s: %d sel\n", text("cells_o0"), sel_nol))

      # Kesimpulan Asumsi
      cat("\n📌 KESIMPULAN ASUMSI:\n")
      if (sel_kurang_1 > 0) {
        status_asumsi <- text("assumption_violation_severe")
      } else if (persen_kurang_5 > 20) {
        status_asumsi <- text("assumption_violation")
      } else {
        status_asumsi <- text("assumption_met")
      }
      cat(sprintf("   %s\n", status_asumsi))

      # Rekomendasi
      if (persen_kurang_5 > 20 || sel_kurang_1 > 0) {
        cat("\n")
        cat(text("recommendation"))
        cat("\n")
      }
      cat(rep("─", 75), "\n", sep = "")
      cat("\n")
    }

    # Jeda
    cat(text("loop_message"))
    cat("\n\n")
  }
}

# ============================================================================
# FUNGSI PEMBANTU: VERSI SIMPEL (TANPA INTERAKTIF)
# ============================================================================

#' Versi Simpel Laporan Statistik (Tanpa Interaktif)
#'
#' Fungsi ini adalah versi sederhana yang langsung mencetak semua laporan
#' tanpa menu interaktif.
#'
#' @param dat Objek tabyl dua arah
#' @param title Judul laporan
#' @param language Bahasa ("id" atau "en")
#' @export
#'
#' @examples
#' \dontrun{
#' tabel <- tabyl(mtcars, cyl, gear)
#' tabyl_to_statistical_report_simple(tabel)
#' }
tabyl_to_statistical_report_simple <- function(
    dat,
    title = "LAPORAN STATISTIK",
    language = "id"
) {

  if (!inherits(dat, "tabyl")) {
    stop("Input harus berupa objek tabyl")
  }

  matriks_angka <- as.matrix(dat[, -1])
  total_n <- sum(matriks_angka)
  r <- nrow(matriks_angka)
  c <- ncol(matriks_angka)

  matriks_ekspektasi <- (rowSums(matriks_angka) %*% t(colSums(matriks_angka))) / total_n
  dimnames(matriks_ekspektasi) <- list(dat[[1]], colnames(matriks_angka))

  # Uji Chi-Square
  uji_chisq <- chisq.test(matriks_angka, correct = FALSE)
  k_min <- min(r - 1, c - 1)
  cramer_v <- sqrt(as.numeric(uji_chisq$statistic) / (total_n * k_min))

  # Header
  cat("\n", rep("=", 75), "\n", sep = "")
  cat(sprintf("📊 %s\n", toupper(title)))
  cat(sprintf("   Total N: %d | Ukuran Tabel: %d x %d\n", total_n, r, c))
  cat(rep("=", 75), "\n\n", sep = "")

  # 1. Observed
  cat("[1] MATRIKS FREKUENSI AKTUAL (O)\n")
  print(dat, row.names = FALSE)
  cat("\n")

  # 2. Expected
  cat("[2] MATRIKS NILAI HARAPAN (E)\n")
  print(round(matriks_ekspektasi, 2))
  cat("\n")

  # 3. Chi-Square
  cat("[3] UJI HIPOTESIS CHI-SQUARE\n")
  cat(sprintf("   X² = %.4f, df = %d, p-value = %.6f\n",
              uji_chisq$statistic, uji_chisq$parameter, uji_chisq$p.value))
  cat(sprintf("   Cramer's V = %.4f\n", cramer_v))
  cat(sprintf("   Keputusan: %s\n",
              ifelse(uji_chisq$p.value < 0.05, "TOLAK H0 (Ada hubungan)", "GAGAL TOLAK H0")))
  cat("\n")

  # 4. Asumsi
  sel_kurang_5 <- sum(matriks_ekspektasi < 5)
  persen_kurang_5 <- (sel_kurang_5 / length(matriks_ekspektasi)) * 100

  cat("[4] UJI ASUMSI KELAYAKAN\n")
  cat(sprintf("   Sel dengan E < 5: %d (%.2f%%)\n", sel_kurang_5, persen_kurang_5))
  if (persen_kurang_5 > 20) {
    cat("   Status: ⚠️ PELANGGARAN ASUMSI\n")
    cat("   Rekomendasi: Gabungkan kategori atau gunakan Fisher's Exact Test\n")
  } else {
    cat("   Status: ✅ ASUMSI TERPENUHI\n")
  }
  cat(rep("=", 75), "\n\n", sep = "")
}

# ============================================================================
# FUNGSI PEMBANTU: SAVE REPORT TO FILE (SARAN PENINGKATAN)
# ============================================================================

#' Simpan Laporan Statistik ke File
#'
#' Fungsi ini menyimpan laporan statistik ke file teks.
#'
#' @param dat Objek tabyl
#' @param file Path file output (default: "statistical_report.txt")
#' @param title Judul laporan
#' @param language Bahasa ("id" atau "en")
#' @export
#'
#' @examples
#' \dontrun{
#' tabel <- tabyl(mtcars, cyl, gear)
#' tabyl_save_report(tabel, "laporan.txt")
#' }
tabyl_save_report <- function(
    dat,
    file = "statistical_report.txt",
    title = "LAPORAN STATISTIK",
    language = "id"
) {

  # Redirect output ke file
  sink(file)

  # Panggil fungsi simple
  tabyl_to_statistical_report_simple(dat, title, language)

  # Kembalikan output ke console
  sink()

  cat(sprintf("✅ Laporan disimpan ke: %s\n", file))
}
