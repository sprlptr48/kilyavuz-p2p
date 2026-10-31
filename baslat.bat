@echo off
chcp 65001 >nul
title Kilyavuz P2P - Ses ve Ekran Paylasimi
cd /d "%~dp0"
echo =========================================================
echo   KILYAVUZ P2P - SUNUCUSUZ SES VE EKRAN PAYLASIMI
echo =========================================================
echo.
echo Tarayici aciliyor, lutfen bu pencereyi gorusme boyunca kapatmayin...
echo (Mikrofon ve ekran sesi izinleri icin localhost uzerinden acilir.)
echo.
echo Chrome/Edge ozel modda acilir: pencereyi kucultup oyuna gecince
echo yayin FPS'i dusmesin diye arka plan kisitlamalari kapatilir.
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command ^
  "$dir = '%~dp0'.TrimEnd('\'); $http = $null; " ^
  "foreach ($p in @(47823, 47824, 47825, 0)) { " ^
  "  if ($p -eq 0) { $l = New-Object System.Net.Sockets.TcpListener([System.Net.IPAddress]::Loopback, 0); $l.Start(); $p = $l.LocalEndpoint.Port; $l.Stop(); } " ^
  "  try { $h = New-Object System.Net.HttpListener; $h.Prefixes.Add('http://localhost:' + $p + '/'); $h.Start(); $http = $h; $port = $p; break } catch { } " ^
  "} " ^
  "if (-not $http) { Write-Host 'Sunucu baslatilamadi!' -ForegroundColor Red; exit 1 } " ^
  "$url = 'http://localhost:' + $port + '/index.html'; " ^
  "Write-Host ('Uygulama calisiyor: ' + $url) -ForegroundColor Green; " ^
  "$cands = @((Join-Path $env:ProgramFiles 'Google\Chrome\Application\chrome.exe'), (Join-Path ${env:ProgramFiles(x86)} 'Google\Chrome\Application\chrome.exe'), (Join-Path $env:LOCALAPPDATA 'Google\Chrome\Application\chrome.exe'), (Join-Path ${env:ProgramFiles(x86)} 'Microsoft\Edge\Application\msedge.exe'), (Join-Path $env:ProgramFiles 'Microsoft\Edge\Application\msedge.exe')); " ^
  "$browser = $cands | Where-Object { Test-Path $_ } | Select-Object -First 1; " ^
  "$prof = Join-Path $env:LOCALAPPDATA 'KilyavuzP2P\TarayiciProfili'; " ^
  "if ($browser) { " ^
  "  Write-Host ('Tarayici: ' + $browser) -ForegroundColor DarkGray; " ^
  "  Start-Process -FilePath $browser -ArgumentList @(('--app=' + $url), ('--user-data-dir=' + $prof), '--disable-backgrounding-occluded-windows', '--disable-renderer-backgrounding', '--disable-background-timer-throttling', '--disable-features=CalculateNativeWinOcclusion,IntensiveWakeUpThrottling', '--no-first-run', '--no-default-browser-check') " ^
  "} else { Start-Process $url } " ^
  "$file = Join-Path $dir 'index.html'; " ^
  "while ($http.IsListening) { " ^
  "  try { " ^
  "    $ctx = $http.GetContext(); $res = $ctx.Response; " ^
  "    $bytes = [System.IO.File]::ReadAllBytes($file); " ^
  "    $res.ContentType = 'text/html; charset=utf-8'; " ^
  "    $res.Headers.Add('Cache-Control', 'no-store'); " ^
  "    $res.ContentLength64 = $bytes.Length; " ^
  "    $res.OutputStream.Write($bytes, 0, $bytes.Length); " ^
  "    $res.OutputStream.Close(); " ^
  "  } catch { } " ^
  "}"
pause
