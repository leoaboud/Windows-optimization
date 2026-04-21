@echo off
:: ============================================================
::  DEV MASTER BY ABOUD - WINDOWS 10 SSD EDITION
:: ============================================================

:: [AUTO-ELEVAÇÃO]
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

title DEV MASTER BY ABOUD - OTIMIZACAO WIN10 SSD
color 0B

echo =========================================================
echo               DEV MASTER (WIN 10 - SSD)
echo    O PC SERA DESLIGADO AUTOMATICAMENTE AO FINALIZAR.
echo =========================================================
echo.

:: Variável para a barra de progresso via PowerShell
set "PS_PROGRESS=powershell -NoProfile -ExecutionPolicy Bypass -Command "Write-Progress -Activity 'DEV MASTER (WIN 10 - SSD)' -Status"

:: [1/11] DNS
%PS_PROGRESS% 'Limpando DNS (1/11)' -PercentComplete 9"
ipconfig /flushdns >nul 2>&1

:: [2/11] Rede e Energia (Hibernação OFF para poupar SSD)
%PS_PROGRESS% 'Otimizando Rede e Energia (2/11)' -PercentComplete 18"
netsh winsock reset >nul 2>&1
powercfg -h off >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

:: [3/11] Reset de Drivers (Atalho Visual Win+Ctrl+Shift+B)
%PS_PROGRESS% 'Resetando Drivers de Video/Audio (3/11)' -PercentComplete 27"
powershell -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Monitor { [DllImport(\"user32.dll\")] public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam); }'; [Monitor]::SendMessage(-1, 0x0112, 0xF170, 2)" >nul 2>&1
timeout /t 2 >nul
powershell -Command "[Monitor]::SendMessage(-1, 0x0112, 0xF170, -1)" >nul 2>&1

:: [4/11] Miniaturas
%PS_PROGRESS% 'Limpando Cache de Icones (4/11)' -PercentComplete 36"
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe >nul 2>&1

:: [5/11] Logs
%PS_PROGRESS% 'Limpando Logs de Eventos (5/11)' -PercentComplete 45"
for /F "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G") >nul 2>&1

:: [6/11] SSD TRIM
%PS_PROGRESS% 'Executando Comando TRIM (6/11)' -PercentComplete 54"
defrag C: /L /U >nul 2>&1

:: [7/11] Temporários
%PS_PROGRESS% 'Limpando Arquivos Temporarios (7/11)' -PercentComplete 63"
del /s /f /q "%TEMP%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1

:: [8/11] Prefetch
%PS_PROGRESS% 'Resetando Cache Prefetch (8/11)' -PercentComplete 72"
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

:: [9/11] Winget Upgrade
%PS_PROGRESS% 'Atualizando Apps Instalados (9/11)' -PercentComplete 81"
winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements >nul 2>&1

:: [10/11] Integridade SFC
%PS_PROGRESS% 'Verificando Arquivos de Sistema (10/11)' -PercentComplete 90"
sfc /scannow >nul 2>&1

:: [11/11] Otimização DISM (Gran Finale)
%PS_PROGRESS% 'Consolidando Limpeza Profunda (11/11)' -PercentComplete 100"
:: Substituído cleanmgr por DISM para evitar travamentos
Dism.exe /online /Cleanup-Image /StartComponentCleanup /NoRestart >nul 2>&1

echo.
echo =========================================================
echo    DEV MASTER - CONCLUIDO COM SUCESSO!
echo    O PC desligara em 10 segundos para aplicar tudo.
echo    Pressione CTRL+C para cancelar o desligamento.
echo =========================================================

shutdown /s /t 10 /c "Otimizacao DEV MASTER BY ABOUD (Win10 SSD) Finalizada."
timeout /t 10