@echo off
setlocal
cd /d "%~dp0"
title Bank Soal - SQL ^& Python Practice Arena

set PYO_VER=0.26.4
set PORT=8000
set PYO_URL=https://github.com/pyodide/pyodide/releases/download/%PYO_VER%/pyodide-core-%PYO_VER%.tar.bz2

REM ---- 1. Cari Python ----
set PY=
where py >nul 2>nul && set PY=py
if not defined PY ( where python >nul 2>nul && set PY=python )
if not defined PY (
  echo [ERROR] Python belum terpasang.
  echo Install dari https://www.python.org/downloads/ lalu centang "Add python.exe to PATH".
  pause
  exit /b 1
)

REM ---- 2. Siapkan Pyodide (sekali saja) ----
if exist "pyodide\pyodide.js" goto :serve
echo Pyodide belum ada. Mengunduh (sekali saja, +/- 5 MB)...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%PYO_URL%' -OutFile 'pyodide.tar.bz2' -UseBasicParsing } catch { exit 1 }"
if errorlevel 1 (
  echo.
  echo [GAGAL] Tidak bisa mengunduh Pyodide. Coba VPN / hotspot HP, lalu jalankan lagi.
  echo Atau unduh manual: %PYO_URL%
  echo lalu ekstrak sampai ada file pyodide\pyodide.js
  pause
  exit /b 1
)
tar -xjf pyodide.tar.bz2
del pyodide.tar.bz2 >nul 2>nul
if not exist "pyodide\pyodide.js" (
  echo [GAGAL] Ekstrak gagal. Pastikan file pyodide\pyodide.js ada.
  pause
  exit /b 1
)
echo Pyodide siap.

:serve
REM ---- 3. Cari file HTML otomatis (nama bebas, spasi boleh) ----
set HTML=
if exist "index.html" set "HTML=index.html"
if not defined HTML if exist "Bank_soal.html" set "HTML=Bank_soal.html"
if not defined HTML for %%f in (*.html) do if not defined HTML set "HTML=%%f"
if not defined HTML (
  echo [ERROR] Tidak ada file .html di folder ini.
  pause
  exit /b 1
)
setlocal enabledelayedexpansion
set "URL=!HTML: =%%20!"

echo.
echo Server jalan di http://localhost:%PORT%/%URL%
echo Tutup jendela ini untuk menghentikan server.
start "" "http://localhost:%PORT%/%URL%"
%PY% -m http.server %PORT% --bind 127.0.0.1