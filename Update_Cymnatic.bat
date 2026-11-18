@echo off
setlocal
title Update Materi Cymnatic
set "URL=https://github.com/VanoStudio/cymnatic-web/archive/HEAD.zip"
echo.
echo  Update materi Cymnatic
echo  ----------------------
echo.
for /f "usebackq delims=" %%D in (`powershell -NoProfile -Command "[Environment]::GetFolderPath('Desktop')"`) do set "DESK=%%D"
if not defined DESK set "DESK=%USERPROFILE%\Desktop"
set "DEST=%DESK%\Cymnatic"
set "TMPD=%TEMP%\cymnatic_update"
if exist "%TMPD%" rmdir /s /q "%TMPD%"
mkdir "%TMPD%"
if not exist "%DEST%\Materi" mkdir "%DEST%\Materi"
if not exist "%DEST%\Kerjaku" mkdir "%DEST%\Kerjaku"
echo Mengunduh materi terbaru...
powershell -NoProfile -ExecutionPolicy Bypass -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12; try { Invoke-WebRequest -UseBasicParsing -Uri '%URL%' -OutFile '%TMPD%\materi.zip' } catch { exit 1 }"
if errorlevel 1 goto gagal
echo Mengekstrak...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Expand-Archive -Force -Path '%TMPD%\materi.zip' -DestinationPath '%TMPD%\x' } catch { exit 1 }"
if errorlevel 1 goto gagal
set "SRC="
for /d %%D in ("%TMPD%\x\*") do set "SRC=%%D"
if not defined SRC goto gagal
if not exist "%SRC%\checkpoint" goto gagal
robocopy "%SRC%\checkpoint" "%DEST%\Materi" /E /NFL /NDL /NJH /NJS /NP >nul
if errorlevel 8 goto gagal
rmdir /s /q "%TMPD%"
echo.
echo Selesai! Materi terbaru ada di folder Cymnatic\Materi di Desktop.
echo Kerjakan tugasmu di folder Cymnatic\Kerjaku.
start "" "%DEST%"
echo.
pause
exit /b 0

:gagal
echo.
echo Gagal memperbarui materi. Periksa koneksi internet, lalu coba lagi.
echo Kalau masih gagal, beri tahu kakak pembimbing.
echo.
pause
exit /b 1
