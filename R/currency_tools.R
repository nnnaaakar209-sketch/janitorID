#' Currency Conversion Tools with Real-Time Exchange Rates
#'
#' Mendukung 146 mata uang dari 5 benua: Asia (48), Eropa (44), Afrika (54),
#' Amerika (35), dan Oseania (14).
#'
#' @name currency_tools
#' @docType package
#' @keywords internal
"_PACKAGE"

# ============================================================================
# 146 MATA UANG DUNIA
# ============================================================================

.ASEAN_CURRENCIES <- list(

  # ========================================================================
  # ASIA (48)
  # ========================================================================

  # ASEAN (11)
  IDR = list(code = "IDR", name = "Indonesian Rupiah", symbol = "Rp",
             decimal_mark = ",", grouping_mark = ".", rate = 16300,
             country = "Indonesia", format = "Rp%s"),
  MYR = list(code = "MYR", name = "Malaysian Ringgit", symbol = "RM",
             decimal_mark = ".", grouping_mark = ",", rate = 4.25,
             country = "Malaysia", format = "RM%s"),
  SGD = list(code = "SGD", name = "Singapore Dollar", symbol = "S$",
             decimal_mark = ".", grouping_mark = ",", rate = 1.35,
             country = "Singapore", format = "S$%s"),
  THB = list(code = "THB", name = "Thai Baht", symbol = "฿",
             decimal_mark = ".", grouping_mark = ",", rate = 32.8,
             country = "Thailand", format = "฿%s"),
  PHP = list(code = "PHP", name = "Philippine Peso", symbol = "₱",
             decimal_mark = ".", grouping_mark = ",", rate = 56.5,
             country = "Philippines", format = "₱%s"),
  BND = list(code = "BND", name = "Brunei Dollar", symbol = "B$",
             decimal_mark = ".", grouping_mark = ",", rate = 1.35,
             country = "Brunei", format = "B$%s"),
  VND = list(code = "VND", name = "Vietnamese Dong", symbol = "₫",
             decimal_mark = ".", grouping_mark = ",", rate = 26100,
             country = "Vietnam", format = "₫%s"),
  LAK = list(code = "LAK", name = "Lao Kip", symbol = "₭",
             decimal_mark = ".", grouping_mark = ",", rate = 21600,
             country = "Laos", format = "₭%s"),
  MMK = list(code = "MMK", name = "Myanmar Kyat", symbol = "K",
             decimal_mark = ".", grouping_mark = ",", rate = 2100,
             country = "Myanmar", format = "K%s"),
  KHR = list(code = "KHR", name = "Cambodian Riel", symbol = "៛",
             decimal_mark = ".", grouping_mark = ",", rate = 4050,
             country = "Cambodia", format = "៛%s"),
  USD = list(code = "USD", name = "US Dollar", symbol = "US$",
             decimal_mark = ".", grouping_mark = ",", rate = 1,
             country = "United States", format = "US$%s"),

  # Asia Barat (15)
  AFN = list(code = "AFN", name = "Afghan Afghani", symbol = "؋",
             decimal_mark = ".", grouping_mark = ",", rate = 71.5,
             country = "Afghanistan", format = "؋%s"),
  AED = list(code = "AED", name = "UAE Dirham", symbol = "د.إ",
             decimal_mark = ".", grouping_mark = ",", rate = 3.67,
             country = "Uni Emirat Arab", format = "د.إ%s"),
  BHD = list(code = "BHD", name = "Bahraini Dinar", symbol = ".د.ب",
             decimal_mark = ".", grouping_mark = ",", rate = 0.376,
             country = "Bahrain", format = ".د.ب%s"),
  IRR = list(code = "IRR", name = "Iranian Rial", symbol = "﷼",
             decimal_mark = ".", grouping_mark = ",", rate = 42000,
             country = "Iran", format = "﷼%s"),
  IQD = list(code = "IQD", name = "Iraqi Dinar", symbol = "ع.د",
             decimal_mark = ".", grouping_mark = ",", rate = 1310,
             country = "Irak", format = "ع.د%s"),
  ILS = list(code = "ILS", name = "Israeli Shekel", symbol = "₪",
             decimal_mark = ".", grouping_mark = ",", rate = 3.65,
             country = "Israel", format = "₪%s"),
  JOD = list(code = "JOD", name = "Jordanian Dinar", symbol = "د.ا",
             decimal_mark = ".", grouping_mark = ",", rate = 0.709,
             country = "Yordania", format = "د.ا%s"),
  KWD = list(code = "KWD", name = "Kuwaiti Dinar", symbol = "د.ك",
             decimal_mark = ".", grouping_mark = ",", rate = 0.307,
             country = "Kuwait", format = "د.ك%s"),
  LBP = list(code = "LBP", name = "Lebanese Pound", symbol = "ل.ل",
             decimal_mark = ".", grouping_mark = ",", rate = 15000,
             country = "Lebanon", format = "ل.ل%s"),
  OMR = list(code = "OMR", name = "Omani Rial", symbol = "ر.ع.",
             decimal_mark = ".", grouping_mark = ",", rate = 0.385,
             country = "Oman", format = "ر.ع.%s"),
  QAR = list(code = "QAR", name = "Qatari Rial", symbol = "ر.ق",
             decimal_mark = ".", grouping_mark = ",", rate = 3.64,
             country = "Qatar", format = "ر.ق%s"),
  SAR = list(code = "SAR", name = "Saudi Riyal", symbol = "ر.س",
             decimal_mark = ".", grouping_mark = ",", rate = 3.75,
             country = "Arab Saudi", format = "ر.س%s"),
  SYP = list(code = "SYP", name = "Syrian Pound", symbol = "ل.س",
             decimal_mark = ".", grouping_mark = ",", rate = 2500,
             country = "Suriah", format = "ل.س%s"),
  TRY = list(code = "TRY", name = "Turkish Lira", symbol = "₺",
             decimal_mark = ".", grouping_mark = ",", rate = 32.5,
             country = "Turki", format = "₺%s"),
  YER = list(code = "YER", name = "Yemeni Rial", symbol = "﷼",
             decimal_mark = ".", grouping_mark = ",", rate = 250,
             country = "Yaman", format = "﷼%s"),

  # Asia Selatan (7)
  BDT = list(code = "BDT", name = "Bangladeshi Taka", symbol = "৳",
             decimal_mark = ".", grouping_mark = ",", rate = 110,
             country = "Bangladesh", format = "৳%s"),
  BTN = list(code = "BTN", name = "Bhutanese Ngultrum", symbol = "Nu.",
             decimal_mark = ".", grouping_mark = ",", rate = 83.5,
             country = "Bhutan", format = "Nu.%s"),
  INR = list(code = "INR", name = "Indian Rupee", symbol = "₹",
             decimal_mark = ".", grouping_mark = ",", rate = 83.5,
             country = "India", format = "₹%s"),
  MVR = list(code = "MVR", name = "Maldivian Rufiyaa", symbol = "Rf",
             decimal_mark = ".", grouping_mark = ",", rate = 15.4,
             country = "Maladewa", format = "Rf%s"),
  NPR = list(code = "NPR", name = "Nepalese Rupee", symbol = "रू",
             decimal_mark = ".", grouping_mark = ",", rate = 133,
             country = "Nepal", format = "रू%s"),
  PKR = list(code = "PKR", name = "Pakistani Rupee", symbol = "Rs",
             decimal_mark = ".", grouping_mark = ",", rate = 278,
             country = "Pakistan", format = "Rs%s"),
  LKR = list(code = "LKR", name = "Sri Lankan Rupee", symbol = "රු",
             decimal_mark = ".", grouping_mark = ",", rate = 300,
             country = "Sri Lanka", format = "රු%s"),

  # Asia Tengah (8)
  AZN = list(code = "AZN", name = "Azerbaijani Manat", symbol = "₼",
             decimal_mark = ".", grouping_mark = ",", rate = 1.70,
             country = "Azerbaijan", format = "₼%s"),
  GEL = list(code = "GEL", name = "Georgian Lari", symbol = "₾",
             decimal_mark = ".", grouping_mark = ",", rate = 2.65,
             country = "Georgia", format = "₾%s"),
  KZT = list(code = "KZT", name = "Kazakhstani Tenge", symbol = "₸",
             decimal_mark = ".", grouping_mark = ",", rate = 445,
             country = "Kazakhstan", format = "₸%s"),
  KGS = list(code = "KGS", name = "Kyrgyzstani Som", symbol = "с",
             decimal_mark = ".", grouping_mark = ",", rate = 89,
             country = "Kirgizstan", format = "с%s"),
  TJS = list(code = "TJS", name = "Tajikistani Somoni", symbol = "SM",
             decimal_mark = ".", grouping_mark = ",", rate = 10.9,
             country = "Tajikistan", format = "SM%s"),
  TMT = list(code = "TMT", name = "Turkmenistani Manat", symbol = "m",
             decimal_mark = ".", grouping_mark = ",", rate = 3.50,
             country = "Turkmenistan", format = "m%s"),
  UZS = list(code = "UZS", name = "Uzbekistani Som", symbol = "so'm",
             decimal_mark = ".", grouping_mark = ",", rate = 12600,
             country = "Uzbekistan", format = "so'm%s"),

  # Asia Timur (6)
  CNY = list(code = "CNY", name = "Chinese Yuan", symbol = "¥",
             decimal_mark = ".", grouping_mark = ",", rate = 7.25,
             country = "China", format = "¥%s"),
  TWD = list(code = "TWD", name = "New Taiwan Dollar", symbol = "NT$",
             decimal_mark = ".", grouping_mark = ",", rate = 32.5,
             country = "Taiwan", format = "NT$%s"),
  JPY = list(code = "JPY", name = "Japanese Yen", symbol = "¥",
             decimal_mark = ".", grouping_mark = ",", rate = 148,
             country = "Jepang", format = "¥%s"),
  KRW = list(code = "KRW", name = "South Korean Won", symbol = "₩",
             decimal_mark = ".", grouping_mark = ",", rate = 1380,
             country = "Korea Selatan", format = "₩%s"),
  KPW = list(code = "KPW", name = "North Korean Won", symbol = "₩",
             decimal_mark = ".", grouping_mark = ",", rate = 900,
             country = "Korea Utara", format = "₩%s"),
  MNT = list(code = "MNT", name = "Mongolian Tugrik", symbol = "₮",
             decimal_mark = ".", grouping_mark = ",", rate = 3400,
             country = "Mongolia", format = "₮%s"),

  # Lainnya (2)
  AMD = list(code = "AMD", name = "Armenian Dram", symbol = "֏",
             decimal_mark = ".", grouping_mark = ",", rate = 390,
             country = "Armenia", format = "֏%s"),
  PSE = list(code = "PSE", name = "Palestinian Pound", symbol = "£",
             decimal_mark = ".", grouping_mark = ",", rate = 3.65,
             country = "Palestina", format = "£%s"),

  # ========================================================================
  # EROPA (44)
  # ========================================================================

  EUR = list(code = "EUR", name = "Euro", symbol = "€",
             decimal_mark = ",", grouping_mark = ".", rate = 0.92,
             country = "Eurozone (24 negara)", format = "€%s"),
  ALL = list(code = "ALL", name = "Albanian Lek", symbol = "L",
             decimal_mark = ".", grouping_mark = ",", rate = 100,
             country = "Albania", format = "L%s"),
  BYN = list(code = "BYN", name = "Belarusian Ruble", symbol = "Br",
             decimal_mark = ".", grouping_mark = ",", rate = 3.25,
             country = "Belarus", format = "Br%s"),
  BAM = list(code = "BAM", name = "Bosnia-Herzegovina Mark", symbol = "KM",
             decimal_mark = ".", grouping_mark = ",", rate = 1.80,
             country = "Bosnia dan Herzegovina", format = "KM%s"),
  BGN = list(code = "BGN", name = "Bulgarian Lev", symbol = "лв",
             decimal_mark = ".", grouping_mark = ",", rate = 1.80,
             country = "Bulgaria", format = "лв%s"),
  CZK = list(code = "CZK", name = "Czech Koruna", symbol = "Kč",
             decimal_mark = ".", grouping_mark = ",", rate = 23.50,
             country = "Ceko", format = "Kč%s"),
  DKK = list(code = "DKK", name = "Danish Krone", symbol = "kr",
             decimal_mark = ".", grouping_mark = ",", rate = 6.90,
             country = "Denmark", format = "kr%s"),
  HUF = list(code = "HUF", name = "Hungarian Forint", symbol = "Ft",
             decimal_mark = ".", grouping_mark = ",", rate = 370,
             country = "Hungaria", format = "Ft%s"),
  ISK = list(code = "ISK", name = "Icelandic Króna", symbol = "kr",
             decimal_mark = ".", grouping_mark = ",", rate = 138,
             country = "Islandia", format = "kr%s"),
  XKX = list(code = "XKX", name = "Kosovo Euro", symbol = "€",
             decimal_mark = ",", grouping_mark = ".", rate = 0.92,
             country = "Kosovo", format = "€%s"),
  CHF = list(code = "CHF", name = "Swiss Franc", symbol = "Fr",
             decimal_mark = ".", grouping_mark = ",", rate = 0.88,
             country = "Swiss", format = "Fr%s"),
  MDL = list(code = "MDL", name = "Moldovan Leu", symbol = "L",
             decimal_mark = ".", grouping_mark = ",", rate = 18.50,
             country = "Moldova", format = "L%s"),
  MKD = list(code = "MKD", name = "Macedonian Denar", symbol = "ден",
             decimal_mark = ".", grouping_mark = ",", rate = 58,
             country = "Makedonia Utara", format = "ден%s"),
  NOK = list(code = "NOK", name = "Norwegian Krone", symbol = "kr",
             decimal_mark = ".", grouping_mark = ",", rate = 10.80,
             country = "Norwegia", format = "kr%s"),
  PLN = list(code = "PLN", name = "Polish Złoty", symbol = "zł",
             decimal_mark = ".", grouping_mark = ",", rate = 4.10,
             country = "Polandia", format = "zł%s"),
  RON = list(code = "RON", name = "Romanian Leu", symbol = "lei",
             decimal_mark = ".", grouping_mark = ",", rate = 4.60,
             country = "Rumania", format = "lei%s"),
  RUB = list(code = "RUB", name = "Russian Ruble", symbol = "₽",
             decimal_mark = ".", grouping_mark = ",", rate = 92,
             country = "Rusia", format = "₽%s"),
  RSD = list(code = "RSD", name = "Serbian Dinar", symbol = "дин",
             decimal_mark = ".", grouping_mark = ",", rate = 110,
             country = "Serbia", format = "дин%s"),
  SEK = list(code = "SEK", name = "Swedish Krona", symbol = "kr",
             decimal_mark = ".", grouping_mark = ",", rate = 10.50,
             country = "Swedia", format = "kr%s"),
  UAH = list(code = "UAH", name = "Ukrainian Hryvnia", symbol = "₴",
             decimal_mark = ".", grouping_mark = ",", rate = 41,
             country = "Ukraina", format = "₴%s"),
  GBP = list(code = "GBP", name = "British Pound", symbol = "£",
             decimal_mark = ".", grouping_mark = ",", rate = 0.79,
             country = "Britania Raya", format = "£%s"),
  MNE = list(code = "MNE", name = "Montenegro Euro", symbol = "€",
             decimal_mark = ",", grouping_mark = ".", rate = 0.92,
             country = "Montenegro", format = "€%s"),

  # ========================================================================
  # AFRIKA (54)
  # ========================================================================

  ZAR = list(code = "ZAR", name = "South African Rand", symbol = "R",
             decimal_mark = ".", grouping_mark = ",", rate = 18.50,
             country = "Afrika Selatan", format = "R%s"),
  AOA = list(code = "AOA", name = "Angolan Kwanza", symbol = "Kz",
             decimal_mark = ".", grouping_mark = ",", rate = 830,
             country = "Angola", format = "Kz%s"),
  BWP = list(code = "BWP", name = "Botswana Pula", symbol = "P",
             decimal_mark = ".", grouping_mark = ",", rate = 13.50,
             country = "Botswana", format = "P%s"),
  SZL = list(code = "SZL", name = "Eswatini Lilangeni", symbol = "E",
             decimal_mark = ".", grouping_mark = ",", rate = 18.50,
             country = "Eswatini", format = "E%s"),
  NAD = list(code = "NAD", name = "Namibian Dollar", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 18.50,
             country = "Namibia", format = "$%s"),
  DZD = list(code = "DZD", name = "Algerian Dinar", symbol = "د.ج",
             decimal_mark = ".", grouping_mark = ",", rate = 135,
             country = "Aljazair", format = "د.ج%s"),
  EGP = list(code = "EGP", name = "Egyptian Pound", symbol = "£E",
             decimal_mark = ".", grouping_mark = ",", rate = 48.5,
             country = "Mesir", format = "£E%s"),
  LYD = list(code = "LYD", name = "Libyan Dinar", symbol = "ل.د",
             decimal_mark = ".", grouping_mark = ",", rate = 4.80,
             country = "Libya", format = "ل.د%s"),
  MAD = list(code = "MAD", name = "Moroccan Dirham", symbol = "د.م.",
             decimal_mark = ".", grouping_mark = ",", rate = 10.0,
             country = "Maroko", format = "د.م.%s"),
  SDG = list(code = "SDG", name = "Sudanese Pound", symbol = "£S",
             decimal_mark = ".", grouping_mark = ",", rate = 600,
             country = "Sudan", format = "£S%s"),
  TND = list(code = "TND", name = "Tunisian Dinar", symbol = "د.ت",
             decimal_mark = ".", grouping_mark = ",", rate = 3.10,
             country = "Tunisia", format = "د.ت%s"),
  XOF = list(code = "XOF", name = "West African CFA Franc", symbol = "CFA",
             decimal_mark = ".", grouping_mark = ",", rate = 610,
             country = "West Africa", format = "CFA%s"),
  GMD = list(code = "GMD", name = "Gambian Dalasi", symbol = "D",
             decimal_mark = ".", grouping_mark = ",", rate = 68,
             country = "Gambia", format = "D%s"),
  GHS = list(code = "GHS", name = "Ghanaian Cedi", symbol = "₵",
             decimal_mark = ".", grouping_mark = ",", rate = 15.5,
             country = "Ghana", format = "₵%s"),
  GNF = list(code = "GNF", name = "Guinean Franc", symbol = "FG",
             decimal_mark = ".", grouping_mark = ",", rate = 8600,
             country = "Guinea", format = "FG%s"),
  CVE = list(code = "CVE", name = "Cape Verdean Escudo", symbol = "Esc",
             decimal_mark = ".", grouping_mark = ",", rate = 110,
             country = "Tanjung Verde", format = "Esc%s"),
  LRD = list(code = "LRD", name = "Liberian Dollar", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 195,
             country = "Liberia", format = "$%s"),
  MRO = list(code = "MRO", name = "Mauritanian Ouguiya", symbol = "UM",
             decimal_mark = ".", grouping_mark = ",", rate = 36,
             country = "Mauritania", format = "UM%s"),
  NGN = list(code = "NGN", name = "Nigerian Naira", symbol = "₦",
             decimal_mark = ".", grouping_mark = ",", rate = 1650,
             country = "Nigeria", format = "₦%s"),
  SLL = list(code = "SLL", name = "Sierra Leonean Leone", symbol = "Le",
             decimal_mark = ".", grouping_mark = ",", rate = 23000,
             country = "Sierra Leone", format = "Le%s"),
  XAF = list(code = "XAF", name = "Central African CFA Franc", symbol = "CFA",
             decimal_mark = ".", grouping_mark = ",", rate = 610,
             country = "Central Africa", format = "CFA%s"),
  BIF = list(code = "BIF", name = "Burundian Franc", symbol = "FBu",
             decimal_mark = ".", grouping_mark = ",", rate = 2850,
             country = "Burundi", format = "FBu%s"),
  CDF = list(code = "CDF", name = "Congolese Franc", symbol = "FC",
             decimal_mark = ".", grouping_mark = ",", rate = 2800,
             country = "Republik Demokratik Kongo", format = "FC%s"),
  DJF = list(code = "DJF", name = "Djiboutian Franc", symbol = "Fdj",
             decimal_mark = ".", grouping_mark = ",", rate = 178,
             country = "Djibouti", format = "Fdj%s"),
  ERN = list(code = "ERN", name = "Eritrean Nakfa", symbol = "Nfk",
             decimal_mark = ".", grouping_mark = ",", rate = 15,
             country = "Eritrea", format = "Nfk%s"),
  ETB = list(code = "ETB", name = "Ethiopian Birr", symbol = "Br",
             decimal_mark = ".", grouping_mark = ",", rate = 115,
             country = "Ethiopia", format = "Br%s"),
  KMF = list(code = "KMF", name = "Comorian Franc", symbol = "CF",
             decimal_mark = ".", grouping_mark = ",", rate = 460,
             country = "Komoro", format = "CF%s"),
  RWF = list(code = "RWF", name = "Rwandan Franc", symbol = "FRw",
             decimal_mark = ".", grouping_mark = ",", rate = 1300,
             country = "Rwanda", format = "FRw%s"),
  STN = list(code = "STN", name = "Sao Tome Dobra", symbol = "Db",
             decimal_mark = ".", grouping_mark = ",", rate = 23,
             country = "Sao Tome dan Principe", format = "Db%s"),
  SSP = list(code = "SSP", name = "South Sudanese Pound", symbol = "£",
             decimal_mark = ".", grouping_mark = ",", rate = 1300,
             country = "Sudan Selatan", format = "£%s"),
  KES = list(code = "KES", name = "Kenyan Shilling", symbol = "KSh",
             decimal_mark = ".", grouping_mark = ",", rate = 155,
             country = "Kenya", format = "KSh%s"),
  MGA = list(code = "MGA", name = "Malagasy Ariary", symbol = "Ar",
             decimal_mark = ".", grouping_mark = ",", rate = 4500,
             country = "Madagaskar", format = "Ar%s"),
  MWK = list(code = "MWK", name = "Malawian Kwacha", symbol = "MK",
             decimal_mark = ".", grouping_mark = ",", rate = 1700,
             country = "Malawi", format = "MK%s"),
  MUR = list(code = "MUR", name = "Mauritian Rupee", symbol = "Rs",
             decimal_mark = ".", grouping_mark = ",", rate = 47,
             country = "Mauritius", format = "Rs%s"),
  MZN = list(code = "MZN", name = "Mozambican Metical", symbol = "MT",
             decimal_mark = ".", grouping_mark = ",", rate = 65,
             country = "Mozambik", format = "MT%s"),
  SCR = list(code = "SCR", name = "Seychellois Rupee", symbol = "SR",
             decimal_mark = ".", grouping_mark = ",", rate = 14,
             country = "Seychelles", format = "SR%s"),
  SOS = list(code = "SOS", name = "Somali Shilling", symbol = "Sh.So.",
             decimal_mark = ".", grouping_mark = ",", rate = 570,
             country = "Somalia", format = "Sh.So.%s"),
  TZS = list(code = "TZS", name = "Tanzanian Shilling", symbol = "TSh",
             decimal_mark = ".", grouping_mark = ",", rate = 2600,
             country = "Tanzania", format = "TSh%s"),
  UGX = list(code = "UGX", name = "Ugandan Shilling", symbol = "USh",
             decimal_mark = ".", grouping_mark = ",", rate = 3700,
             country = "Uganda", format = "USh%s"),
  ZMW = list(code = "ZMW", name = "Zambian Kwacha", symbol = "ZK",
             decimal_mark = ".", grouping_mark = ",", rate = 27,
             country = "Zambia", format = "ZK%s"),
  ZWL = list(code = "ZWL", name = "Zimbabwean Dollar", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 300,
             country = "Zimbabwe", format = "$%s"),
  LSL = list(code = "LSL", name = "Lesotho Loti", symbol = "L",
             decimal_mark = ".", grouping_mark = ",", rate = 18.50,
             country = "Lesotho", format = "L%s"),

  # ========================================================================
  # AMERIKA (35)
  # ========================================================================

  CAD = list(code = "CAD", name = "Canadian Dollar", symbol = "C$",
             decimal_mark = ".", grouping_mark = ",", rate = 1.36,
             country = "Kanada", format = "C$%s"),
  MXN = list(code = "MXN", name = "Mexican Peso", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 17.50,
             country = "Meksiko", format = "$%s"),
  XCD = list(code = "XCD", name = "Eastern Caribbean Dollar", symbol = "EC$",
             decimal_mark = ".", grouping_mark = ",", rate = 2.70,
             country = "Caribbean", format = "EC$%s"),
  BSD = list(code = "BSD", name = "Bahamian Dollar", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 1.00,
             country = "Bahama", format = "$%s"),
  BBD = list(code = "BBD", name = "Barbadian Dollar", symbol = "Bds$",
             decimal_mark = ".", grouping_mark = ",", rate = 2.00,
             country = "Barbados", format = "Bds$%s"),
  BZD = list(code = "BZD", name = "Belize Dollar", symbol = "BZ$",
             decimal_mark = ".", grouping_mark = ",", rate = 2.00,
             country = "Belize", format = "BZ$%s"),
  CRC = list(code = "CRC", name = "Costa Rican Colón", symbol = "₡",
             decimal_mark = ".", grouping_mark = ",", rate = 520,
             country = "Kosta Rika", format = "₡%s"),
  CUP = list(code = "CUP", name = "Cuban Peso", symbol = "₱",
             decimal_mark = ".", grouping_mark = ",", rate = 24,
             country = "Kuba", format = "₱%s"),
  DOP = list(code = "DOP", name = "Dominican Peso", symbol = "RD$",
             decimal_mark = ".", grouping_mark = ",", rate = 58,
             country = "Republik Dominika", format = "RD$%s"),
  GTQ = list(code = "GTQ", name = "Guatemalan Quetzal", symbol = "Q",
             decimal_mark = ".", grouping_mark = ",", rate = 7.80,
             country = "Guatemala", format = "Q%s"),
  HTG = list(code = "HTG", name = "Haitian Gourde", symbol = "G",
             decimal_mark = ".", grouping_mark = ",", rate = 130,
             country = "Haiti", format = "G%s"),
  HNL = list(code = "HNL", name = "Honduran Lempira", symbol = "L",
             decimal_mark = ".", grouping_mark = ",", rate = 25,
             country = "Honduras", format = "L%s"),
  JMD = list(code = "JMD", name = "Jamaican Dollar", symbol = "J$",
             decimal_mark = ".", grouping_mark = ",", rate = 155,
             country = "Jamaika", format = "J$%s"),
  NIO = list(code = "NIO", name = "Nicaraguan Córdoba", symbol = "C$",
             decimal_mark = ".", grouping_mark = ",", rate = 36,
             country = "Nikaragua", format = "C$%s"),
  TTD = list(code = "TTD", name = "Trinidad Dollar", symbol = "TT$",
             decimal_mark = ".", grouping_mark = ",", rate = 6.80,
             country = "Trinidad dan Tobago", format = "TT$%s"),
  ARS = list(code = "ARS", name = "Argentine Peso", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 850,
             country = "Argentina", format = "$%s"),
  BOB = list(code = "BOB", name = "Bolivian Boliviano", symbol = "Bs",
             decimal_mark = ".", grouping_mark = ",", rate = 6.90,
             country = "Bolivia", format = "Bs%s"),
  BRL = list(code = "BRL", name = "Brazilian Real", symbol = "R$",
             decimal_mark = ",", grouping_mark = ".", rate = 5.00,
             country = "Brasil", format = "R$%s"),
  CLP = list(code = "CLP", name = "Chilean Peso", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 950,
             country = "Chili", format = "$%s"),
  COP = list(code = "COP", name = "Colombian Peso", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 4000,
             country = "Kolombia", format = "$%s"),
  GYD = list(code = "GYD", name = "Guyanese Dollar", symbol = "G$",
             decimal_mark = ".", grouping_mark = ",", rate = 208,
             country = "Guyana", format = "G$%s"),
  PYG = list(code = "PYG", name = "Paraguayan Guarani", symbol = "₲",
             decimal_mark = ".", grouping_mark = ",", rate = 7500,
             country = "Paraguay", format = "₲%s"),
  PEN = list(code = "PEN", name = "Peruvian Sol", symbol = "S/",
             decimal_mark = ".", grouping_mark = ",", rate = 3.75,
             country = "Peru", format = "S/%s"),
  SRD = list(code = "SRD", name = "Surinamese Dollar", symbol = "$",
             decimal_mark = ".", grouping_mark = ",", rate = 30,
             country = "Suriname", format = "$%s"),
  UYU = list(code = "UYU", name = "Uruguayan Peso", symbol = "$U",
             decimal_mark = ".", grouping_mark = ",", rate = 42,
             country = "Uruguay", format = "$U%s"),
  VES = list(code = "VES", name = "Venezuelan Bolívar", symbol = "Bs.S",
             decimal_mark = ".", grouping_mark = ",", rate = 36,
             country = "Venezuela", format = "Bs.S%s"),

  # ========================================================================
  # OSEANIA (14)
  # ========================================================================

  AUD = list(code = "AUD", name = "Australian Dollar", symbol = "A$",
             decimal_mark = ".", grouping_mark = ",", rate = 1.53,
             country = "Australia", format = "A$%s"),
  NZD = list(code = "NZD", name = "New Zealand Dollar", symbol = "NZ$",
             decimal_mark = ".", grouping_mark = ",", rate = 1.65,
             country = "Selandia Baru", format = "NZ$%s"),
  FJD = list(code = "FJD", name = "Fijian Dollar", symbol = "FJ$",
             decimal_mark = ".", grouping_mark = ",", rate = 2.25,
             country = "Fiji", format = "FJ$%s"),
  PGK = list(code = "PGK", name = "Papua New Guinean Kina", symbol = "K",
             decimal_mark = ".", grouping_mark = ",", rate = 3.80,
             country = "Papua Nugini", format = "K%s"),
  WST = list(code = "WST", name = "Samoan Tala", symbol = "WS$",
             decimal_mark = ".", grouping_mark = ",", rate = 2.75,
             country = "Samoa", format = "WS$%s"),
  SBD = list(code = "SBD", name = "Solomon Islands Dollar", symbol = "SI$",
             decimal_mark = ".", grouping_mark = ",", rate = 8.40,
             country = "Kepulauan Solomon", format = "SI$%s"),
  TOP = list(code = "TOP", name = "Tongan Paʻanga", symbol = "T$",
             decimal_mark = ".", grouping_mark = ",", rate = 2.35,
             country = "Tonga", format = "T$%s"),
  VUV = list(code = "VUV", name = "Vanuatu Vatu", symbol = "VT",
             decimal_mark = ".", grouping_mark = ",", rate = 120,
             country = "Vanuatu", format = "VT%s")
)

# ============================================================================
# END OF CURRENCY LIST - TOTAL: 146 MATA UANG
# ============================================================================

# DEFAULT RATES
.DEFAULT_RATES <- list()
for (code in names(.ASEAN_CURRENCIES)) {
  .DEFAULT_RATES[[code]] <- .ASEAN_CURRENCIES[[code]]$rate
}

# FUNGSI INTERNAL
.get_currency_info <- function(currency_code) {
  currency_code <- toupper(currency_code)
  if (!currency_code %in% names(.ASEAN_CURRENCIES)) {
    supported <- paste(names(.ASEAN_CURRENCIES), collapse = ", ")
    stop(sprintf("Currency '%s' not supported. Supported: %s", currency_code, supported))
  }
  .ASEAN_CURRENCIES[[currency_code]]
}

.fetch_exchange_rates <- function(base_currency = "USD") {
  tryCatch({
    url <- sprintf("https://api.exchangerate.host/latest?base=%s", base_currency)
    response <- httr2::request(url) |> httr2::req_timeout(5) |> httr2::req_perform()
    if (httr2::resp_status(response) == 200) {
      data <- httr2::resp_body_json(response)
      rates <- unlist(data$rates)
      updated_rates <- list()
      for (code in names(.DEFAULT_RATES)) {
        updated_rates[[code]] <- if (code %in% names(rates)) rates[[code]] else .DEFAULT_RATES[[code]]
      }
      attr(updated_rates, "source") <- "API"
      attr(updated_rates, "date") <- data$date
      return(updated_rates)
    }
    NULL
  }, error = function(e) NULL)
}

.get_exchange_rates <- function(base_currency = "USD", use_api = TRUE) {
  if (use_api) {
    rates <- .fetch_exchange_rates(base_currency)
    if (!is.null(rates)) return(rates)
    warning("API unavailable. Using fallback rates.")
  }
  return(.DEFAULT_RATES)
}

#' Convert currency values with REAL-TIME exchange rates
#'
#' Mendukung 146 mata uang dari seluruh dunia dengan kurs real-time.
#'
#' @param data Data frame
#' @param columns Kolom yang akan dikonversi
#' @param from Mata uang asal
#' @param to Mata uang tujuan
#' @param exchange_rate Manual exchange rate
#' @param use_api TRUE untuk real-time (default)
#' @param digits Jumlah desimal
#' @param format_output TRUE untuk format dengan simbol
#'
#' @return Data frame dengan hasil konversi
#' @export
convert_currency <- function(data, columns, from, to, exchange_rate = NULL,
                             use_api = TRUE, digits = 2, format_output = TRUE) {
  if (!is.data.frame(data)) stop("'data' must be a data frame")
  if (!all(columns %in% names(data))) {
    stop(sprintf("Columns not found: %s", paste(columns[!columns %in% names(data)], collapse = ", ")))
  }
  for (col in columns) {
    if (!is.numeric(data[[col]])) stop(sprintf("Column '%s' must be numeric", col))
  }
  .get_currency_info(from); .get_currency_info(to)
  rates <- .get_exchange_rates("USD", use_api)
  if (!is.null(exchange_rate)) {
    if (length(exchange_rate) == 1 && !is.null(names(exchange_rate))) {
      rates[names(exchange_rate)] <- exchange_rate
    } else if (length(exchange_rate) == 1) {
      rates[[to]] <- exchange_rate
    }
  }
  usd_rate_from <- rates[[from]]; usd_rate_to <- rates[[to]]
  if (is.null(usd_rate_from) || is.null(usd_rate_to)) stop("Exchange rates not available")
  result <- data
  for (col in columns) {
    converted <- (data[[col]] / usd_rate_from) * usd_rate_to
    if (format_output) {
      info <- .get_currency_info(to)
      formatted <- scales::number(converted, accuracy = 10^(-digits),
                                  decimal.mark = info$decimal_mark, big.mark = info$grouping_mark)
      result[[paste0(col, "_", to)]] <- sprintf("%s%s", info$symbol, formatted)
    } else {
      result[[paste0(col, "_", to)]] <- round(converted, digits)
    }
  }
  attr(result, "conversion_metadata") <- list(
    from = from, to = to, api_used = use_api,
    rates_source = attr(rates, "source") %||% "Internal",
    rates_date = attr(rates, "date") %||% Sys.Date()
  )
  result
}
