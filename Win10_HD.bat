@echo off
:: ============================================================
::  DEV MASTER BY ABOUD - WINDOWS 10 HDD EDITION (PROGRESS)
:: ============================================================

:: [AUTO-ELEVAÇÃO]
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

title DEV MASTER BY ABOUD - OTIMIZACAO WIN10 HDD
color 0B

echo =========================================================
echo               DEV MASTER (WIN 10 HDD)
echo    ESTA VERSAO INCLUI OTIMIZACAO FISICA PARA DISCO RIGIDO.
echo    O PC SERA DESLIGADO AUTOMATICAMENTE AO FINALIZAR.
echo =========================================================
echo.

:: Variável para a barra de progresso via PowerShell
set "PS_PROGRESS=powershell -NoProfile -ExecutionPolicy Bypass -Command "Write-Progress -Activity 'DEV MASTER (WIN 10 HDD)' -Status"

:: [1/12] DNS
%PS_PROGRESS% 'Limpando DNS (1/12)' -PercentComplete 8"
ipconfig /flushdns >nul 2>&1

:: [2/12] Rede e Energia (Hibernação ON para HDDs)
%PS_PROGRESS% 'Ajustando Rede e Energia (2/12)' -PercentComplete 16"
netsh winsock reset >nul 2>&1
powercfg -h on >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1

:: [3/12] Reset de Drivers
%PS_PROGRESS% 'Reiniciando Drivers de Video/Audio (3/12)' -PercentComplete 25"
powershell -Command "Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public class Monitor { [DllImport(\"user32.dll\")] public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam); }'; [Monitor]::SendMessage(-1, 0x0112, 0xF170, 2)" >nul 2>&1
timeout /t 2 >nul
powershell -Command "[Monitor]::SendMessage(-1, 0x0112, 0xF170, -1)" >nul 2>&1

:: [4/12] Miniaturas
%PS_PROGRESS% 'Limpando Cache de Icones (4/12)' -PercentComplete 33"
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe >nul 2>&1

:: [5/12] Logs
%PS_PROGRESS% 'Limpando Logs de Eventos (5/12)' -PercentComplete 41"
for /F "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G") >nul 2>&1

:: [6/12] Temporários
%PS_PROGRESS% 'Limpando Arquivos Temporarios (6/12)' -PercentComplete 50"
del /s /f /q "%TEMP%\*.*" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1

:: [7/12] Prefetch
%PS_PROGRESS% 'Resetando Cache Prefetch (7/12)' -PercentComplete 58"
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1

:: [8/12] Winget
%PS_PROGRESS% 'Atualizando Apps via Winget (8/12)' -PercentComplete 66"
winget upgrade --all --include-unknown --accept-package-agreements --accept-source-agreements >nul 2>&1

:: [9/12] SFC
%PS_PROGRESS% 'Validando Arquivos de Sistema (9/12)' -PercentComplete 75"
sfc /scannow >nul 2>&1

:: [10/12] WinSxS
%PS_PROGRESS% 'Otimizando Nucleo (10/12)' -PercentComplete 83"
Dism.exe /online /Cleanup-Image /StartComponentCleanup >nul 2>&1

:: [11/12] DISM Final
%PS_PROGRESS% 'Consolidando Limpeza Profunda (11/12)' -PercentComplete 91"
Dism.exe /online /Cleanup-Image /StartComponentCleanup /NoRestart >nul 2>&1

:: [12/12] DESFRAGMENTAÇÃO (Crucial para HDD)
%PS_PROGRESS% 'DESFRAGMENTANDO DISCO FISICO (12/12)' -PercentComplete 100"
defrag C: /U /V >nul 2>&1

echo.
echo =========================================================
echo    DEV MASTER - CONCLUIDO COM SUCESSO!
echo    O PC desligara em 10 segundos.
echo    Pressione CTRL+C para cancelar o desligamento.
echo =========================================================

shutdown /s /t 10 /c "Manutencao DEV MASTER (Win10 HDD) finalizada."
timeout /t 10