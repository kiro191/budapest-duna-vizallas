# ============================================================
# Budapest, Paks - Duna aktuális vízállás
# Budapest: 1646,500 fkm | Vízügy törzsszám 1026
# Paks:     1531,300 fkm | Vízügy törzsszám 549
# ============================================================

library(rvest)
library(stringr)

# ------------------------------------------------------------
# Vízügy oldalak
# ------------------------------------------------------------

url_budapest <- paste0(
  "https://www.vizugy.hu/",
  "?AllomasVOA=16496059-97AB-11D4-BB62-00508BA24287",
  "&mapData=OrasIdosor",
  "&mapModule=OpGrafikon"
)

url_paks <- paste0(
  "https://www.vizugy.hu/",
  "?AllomasVOA=16496188-97AB-11D4-BB62-00508BA24287",
  "&mapData=OrasIdosor",
  "&mapModule=OpGrafikon"
)

# ------------------------------------------------------------
# Segédfüggvény: legfrissebb mérés kiolvasása
# ------------------------------------------------------------

meres_kiolvas <- function(url) {

  oldal <- read_html(url)

  tablazatok <- html_table(oldal, fill = TRUE)

  if (length(tablazatok) < 1) {
    stop("Nem található táblázat a Vízügy oldalán.")
  }

  adat <- tablazatok[[1]]

  if (nrow(adat) < 1 || ncol(adat) < 8) {
    stop("A Vízügy táblázat szerkezete megváltozott.")
  }

  legfrissebb <- adat[1, ]

  idopont <- as.character(legfrissebb[[7]])
  vizallas <- as.numeric(legfrissebb[[8]])

  list(
    idopont = idopont,
    vizallas = vizallas
  )
}

# ------------------------------------------------------------
# Budapest és Paks adatok lekérése
# ------------------------------------------------------------

budapest <- meres_kiolvas(url_budapest)
paks <- meres_kiolvas(url_paks)

idopont_budapest <- budapest$idopont
vizallas_budapest <- budapest$vizallas

idopont_paks <- paks$idopont
vizallas_paks <- paks$vizallas

# ------------------------------------------------------------
# Konzol
# ------------------------------------------------------------

cat("\n")
cat("============================================================\n")
cat(" BUDAPEST, PAKS - DUNA\n")
cat("============================================================\n")

cat("BUDAPEST\n")
cat(" 1646,500 fkm | törzsszám 1026\n")
cat(" Mérés időpontja: ", idopont_budapest, "\n")
cat(" Vízállás:        ", vizallas_budapest, " cm\n")
cat("\n")

cat("PAKS\n")
cat(" 1531,300 fkm | törzsszám 549\n")
cat(" Mérés időpontja: ", idopont_paks, "\n")
cat(" Vízállás:        ", vizallas_paks, " cm\n")

cat("============================================================\n")

# ------------------------------------------------------------
# TXT fájl
# ------------------------------------------------------------

writeLines(
  c(
    paste0("Budapest idopont=", idopont_budapest),
    paste0("Budapest vizallas=", vizallas_budapest),
    paste0("Paks idopont=", idopont_paks),
    paste0("Paks vizallas=", vizallas_paks)
  ),
  "budapest_vizallas.txt"
)

cat("\nAz adatok elmentve: budapest_vizallas.txt\n")

# ------------------------------------------------------------
# Mobil HTML oldal
# ------------------------------------------------------------

html <- paste0(
"<!DOCTYPE html>
<html lang='hu'>
<head>
<meta charset='UTF-8'>
<meta name='viewport' content='width=device-width, initial-scale=1.0'>

<title>Budapest, Paks vízállásai</title>

<meta property='og:title' content='Budapest, Paks vízállásai'>
<meta property='og:description' content='A Duna aktuális vízállása Budapestnél és Paksnál.'>

<style>

html, body {
    margin: 0;
    padding: 0;
    width: 100%;
    min-height: 100%;
}

body {
    font-family: Arial, Helvetica, sans-serif;
    background: #ffffff;
    color: #111111;
    text-align: center;
}

.container {
    width: 100%;
    max-width: 600px;
    margin: 0 auto;
    padding: 30px 20px 40px;
    box-sizing: border-box;
}

.page-title {
    font-size: 28px;
    font-weight: 600;
    letter-spacing: 2px;
    margin-bottom: 35px;
}

.station-block {
    margin-bottom: 45px;
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
    margin-bottom: 25px;
}

.water {
    font-size: 100px;
    font-weight: 700;
    line-height: 1;
}

.unit {
    font-size: 30px;
    margin-top: 5px;
    margin-bottom: 25px;
}

.time {
    font-size: 18px;
    color: #555555;
}

.source {
    margin-top: 35px;
    font-size: 13px;
    color: #888888;
}

.separator {
    border: 0;
    border-top: 1px solid #dddddd;
    margin: 10px 0 45px;
}

@media (max-width: 420px) {
    .page-title {
        font-size: 24px;
    }

    .water {
        font-size: 90px;
    }

    .city {
        font-size: 25px;
    }
}

</style>
</head>

<body>

<div class='container'>

    <div class='page-title'>Budapest, Paks vízállásai</div>

    <div class='station-block'>

        <div class='city'>BUDAPEST</div>
        <div class='river'>DUNA</div>
        <div class='station'>1646,5 fkm · vízmérce 1026</div>

        <div class='water'>",
vizallas_budapest,
"</div>

        <div class='unit'>cm</div>

        <div class='time'>",
idopont_budapest,
"</div>

    </div>

    <hr class='separator'>

    <div class='station-block'>

        <div class='city'>PAKS</div>
        <div class='river'>DUNA</div>
        <div class='station'>1531,3 fkm · vízmérce 549</div>

        <div class='water'>",
vizallas_paks,
"</div>

        <div class='unit'>cm</div>

        <div class='time'>",
idopont_paks,
"</div>

    </div>

    <div class='source'>
        Forrás: Vízügy · KDTVIZIG
    </div>

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
