@echo off
:: ============================================================
::  DEV-MASTER BY ABOUD - PROGRESS BAR + AUTO SHUTDOWN (10s)
:: ============================================================

:: [AUTO-ELEVAÇÃO]
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

title DEV-MASTER BY ABOUD - OTIMIZACAO EM ANDAMENTO
color 0A

echo =========================================================
echo               DEV MASTER (WIN 11 - SSD)
echo    O PC SERA DESLIGADO AUTOMATICAMENTE AO FINALIZAR.
echo =========================================================
echo.

:: Variável para a barra de progresso via PowerShell
set "PS_PROGRESS=powershell -NoProfile -ExecutionPolicy Bypass -Command "Write-Progress -Activity 'DEV MASTER (WIN 11 - SSD)' -Status"

:: [1/13] DNS
%PS_PROGRESS% 'Limpando DNS (1/13)' -PercentComplete 8"
ipconfig /flushdns >nul 2>&1

:: [2/13] Rede e Energia
%PS_PROGRESS% 'Ajustando Rede e Energia (2/13)' -PercentComplete 15"
netsh winsock reset >nul 2>&1
powercfg -h off >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

:: [3/13] Reset de Drivers
%PS_PROGRESS% 'Reiniciando Drivers de Video/Audio (3/13)' -PercentComplete 23"
powershell -Command "& {Get-PnpDevice -Status Error | Repair-PnpDevice -Confirm:$false}" >nul 2>&1
powershell -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Monitor { [DllImport(\"user32.dll\")] public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam); }'; [Monitor]::SendMessage(-1, 0x0112, 0xF170, 2)" >nul 2>&1
timeout /t 2 >nul
powershell -Command "[Monitor]::SendMessage(-1, 0x0112, 0xF170, -1)" >nul 2>&1

:: [4/13] MS Store
%PS_PROGRESS% 'Resetando Cache da Loja (4/13)' -PercentComplete 30"
wsreset.exe -i >nul 2>&1

:: [5/13] Miniaturas
%PS_PROGRESS% 'Limpando Cache de Icones (5/13)' -PercentComplete 38"
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe >nul 2>&1

:: [6/13] Logs
%PS_PROGRESS% 'Limpando Logs de Eventos (6/13)' -PercentComplete 46"
for /F "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G") >nul 2>&1

:: [7/13] SSD TRIM
%PS_PROGRESS% 'Otimizando SSD TRIM (7/13)' -PercentComplete 54"
defrag C: /L /U >nul 2>&1

:: [8/13] Temporários
%PS_PROGRESS% 'Limpando Arquivos Temporarios (8/13)' -PercentComplete 61"
del /s /f /q "%TEMP%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1

:: [9/13] Prefetch
%PS_PROGRESS% 'Limpando Prefetch (9/13)' -PercentComplete 69"
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

:: [10/13] Winget
%PS_PROGRESS% 'Atualizando Apps via Winget (10/13)' -PercentComplete 77"
winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements >nul 2>&1

:: [11/13] SFC
%PS_PROGRESS% 'Validando Arquivos de Sistema (11/13)' -PercentComplete 85"
sfc /scannow >nul 2>&1

:: [12/13] WinSxS
%PS_PROGRESS% 'Otimizando Nucleo (12/13)' -PercentComplete 92"
Dism.exe /online /Cleanup-Image /StartComponentCleanup >nul 2>&1

:: [13/13] DISM Final
%PS_PROGRESS% 'Consolidando Limpeza Profunda (13/13)' -PercentComplete 100"
Dism.exe /online /Cleanup-Image /StartComponentCleanup /NoRestart >nul 2>&1

echo.
echo =========================================================
echo    DEV MASTER - CONCLUIDO COM SUCESSO!
echo    O PC desligara em 10 segundos.
echo    Pressione CTRL+C para cancelar o desligamento.
echo =========================================================

shutdown /s /t 10 /c "Otimizacao DEV MASTER Finalizada. O PC sera desligado."
timeout /t 10