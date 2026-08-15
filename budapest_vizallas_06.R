# ============================================================
# Budapest - Duna aktuális vízállás
# Budapest, 1646,500 fkm
# Vízügy - törzsszám 1026
# ============================================================

library(rvest)
library(stringr)

# ------------------------------------------------------------
# Hivatalos Vízügy oldal
# ------------------------------------------------------------

url <- paste0(
  "https://www.vizugy.hu/",
  "?AllomasVOA=16496059-97AB-11D4-BB62-00508BA24287",
  "&mapData=OrasIdosor",
  "&mapModule=OpGrafikon"
)

# ------------------------------------------------------------
# Weboldal letöltése
# ------------------------------------------------------------

oldal <- read_html(url)

# ------------------------------------------------------------
# Táblázat beolvasása
# ------------------------------------------------------------

tablazatok <- html_table(oldal, fill = TRUE)

adat <- tablazatok[[1]]

# ------------------------------------------------------------
# Legfrissebb mérés
# ------------------------------------------------------------

legfrissebb <- adat[1, ]

# ------------------------------------------------------------
# Szükséges adatok kiolvasása
# ------------------------------------------------------------

idopont <- as.character(legfrissebb[[7]])
vizallas <- as.numeric(legfrissebb[[8]])

# ------------------------------------------------------------
# Eredmény megjelenítése
# ------------------------------------------------------------

cat("\n")
cat("========================================\n")
cat(" BUDAPEST - DUNA\n")
cat(" 1646,500 fkm | 1026\n")
cat("========================================\n")
cat("Mérés időpontja: ", idopont, "\n")
cat("Vízállás:        ", vizallas, "cm\n")
cat("========================================\n")

# ------------------------------------------------------------
# Egyszerű adatfájl létrehozása
# ------------------------------------------------------------

writeLines(
  c(
    paste0("idopont=", idopont),
    paste0("vizallas=", vizallas)
  ),
  "budapest_vizallas.txt"
)

cat("\nAz adat elmentve: budapest_vizallas.txt\n")

# ------------------------------------------------------------
# HTML oldal létrehozása
# ------------------------------------------------------------

html <- paste0(
  "<!DOCTYPE html>\n",
  "<html lang='hu'>\n",
  "<head>\n",
  "  <meta charset='UTF-8'>\n",
  "  <meta name='viewport' content='width=device-width, initial-scale=1.0'>\n",
  "  <title>Budapest Duna vízállás</title>\n",
  "</head>\n",
  "<body>\n",
  "  <h1>BUDAPEST – DUNA</h1>\n",
  "  <h2>1646,500 fkm</h2>\n",
  "  <div style='font-size:80px; font-weight:bold;'>",
  vizallas,
  " cm</div>\n",
  "  <p>Mérés időpontja: ",
  idopont,
  "</p>\n",
  "  <p>Forrás: Vízügy – Budapest vízmérce 1026</p>\n",
  "</body>\n",
  "</html>"
)

writeLines(
  html,
  "budapest_vizallas.html",
  useBytes = TRUE
)

cat("HTML oldal elmentve: budapest_vizallas.html\n")

# ------------------------------------------------------------
# HTML oldal létrehozása
# ------------------------------------------------------------

# ------------------------------------------------------------
# Letisztult mobil HTML oldal
# ------------------------------------------------------------

html <- paste0(
  "<!DOCTYPE html>
<html lang='hu'>
<head>
<meta charset='UTF-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0'>

<title>Budapest Duna vízállás</title>

<style>

html, body {
    margin: 0;
    padding: 0;
    width: 100%;
    height: 100%;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #ffffff;
    color: #111111;

    display: flex;
    justify-content: center;
    align-items: center;

    text-align: center;
}

.container {
    width: 100%;
    max-width: 600px;
    padding: 30px 20px;
    box-sizing: border-box;
}

.city {
    font-size: 28px;
    font-weight: 600;
    letter-spacing: 4px;
    margin-bottom: 5px;
}

.river {
    font-size: 22px;
    letter-spacing: 3px;
    margin-bottom: 12px;
}

.station {
    font-size: 16px;
    color: #666666;
    margin-bottom: 45px;
}

.water {
    font-size: 110px;
    font-weight: 700;
    line-height: 1;
}

.unit {
    font-size: 30px;
    margin-top: 5px;
    margin-bottom: 45px;
}

.time {
    font-size: 18px;
    color: #555555;
}

.source {
    margin-top: 50px;
    font-size: 13px;
    color: #888888;
}

</style>
</head>

<body>

<div class='container'>

    <div class='city'>BUDAPEST</div>

    <div class='river'>DUNA</div>

    <div class='station'>1646,5 fkm</div>

    <div class='water'>",
vizallas,
"</div>

    <div class='unit'>cm</div>

    <div class='time'>",
idopont,
"</div>

    <div class='source'>Vízügy · vízmérce 1026</div>

</div>

</body>
</html>"
)

writeLines(
  html,
  "budapest_vizallas.html",
  useBytes = TRUE
)

cat("HTML oldal frissítve: budapest_vizallas.html\n")