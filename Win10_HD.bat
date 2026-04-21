@echo off
:: ============================================================
::  MANUTENCAO AUTOMATIZADA - WINDOWS 10
:: ============================================================

:: [AUTO-ELEVAÇÃO] Solicita permissão de administrador automaticamente
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

title Manutencao Automatica - Windows 10 (HDD Edition)
color 0B

set LOGFILE=%SystemDrive%\manutencao_win10_log.txt
echo Manutencao iniciada em: %date% %time% > "%LOGFILE%"

echo =========================================================
echo  INICIANDO WIN PRO... POR FAVOR, AGUARDE.
echo =========================================================

:: [1/11] Arquivos Temporários
echo [1/11] Limpando arquivos temporarios...
echo Objetivo: Remover lixo digital que ocupa espaco e reduz a velocidade do sistema.
del /s /f /q "%TEMP%\*.*" >nul 2>&1
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
md "C:\Windows\Temp" >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [2/11] Prefetch
echo [2/11] Limpando cache de inicializacao (Prefetch)...
echo Objetivo: Forcar o Windows a recriar o mapa de carregamento de apps para evitar erros.
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [3/11] DNS
echo [3/11] Limpando cache de DNS...
echo Objetivo: Corrigir problemas de conexao com sites e erros de navegador.
ipconfig /flushdns >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [4/11] Miniaturas
echo [4/11] Resetando cache de miniaturas (Thumbnails)...
echo Objetivo: Corrigir erro de icones que nao aparecem ou pastas lentas ao abrir.
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe
echo [OK] >> "%LOGFILE%"

:: [5/11] Cleanmgr
echo [5/11] Executando Limpeza de Disco do Windows...
echo Objetivo: Remocao de instalacoes anteriores e arquivos de sistema obsoletos.
cleanmgr /sagerun:1
echo [OK] >> "%LOGFILE%"

:: [6/11] WinSxS
echo [6/11] Limpando arquivos antigos do Windows Update (WinSxS)...
echo Objetivo: Recuperar muito espaco em disco removendo sobras de atualizacoes.
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo [OK] >> "%LOGFILE%"

:: [7/11] MS Store
echo [7/11] Resetando cache da Windows Store...
echo Objetivo: Resolver bugs na loja e em aplicativos nativos do Windows 10.
wsreset.exe
echo [OK] >> "%LOGFILE%"

:: [8/11] Integridade SFC + DISM
echo [8/11] Verificando e reparando a saude do sistema...
echo Objetivo: Corrigir automaticamente arquivos corrompidos que causam travamentos.
DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow
echo [OK] >> "%LOGFILE%"

:: [9/11] Atualizacoes Winget (Se disponivel)
echo [9/11] Atualizando programas instalados...
echo Objetivo: Manter seus apps na ultima versao de forma silenciosa.
winget upgrade --all --silent --include-unknown >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [10/11] Logs de Eventos
echo [10/11] Limpando logs de eventos antigos...
echo Objetivo: Liberar espaco e limpar o historico de erros do Visualizador de Eventos.
wevtutil cl Application >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Security >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [11/11] Rede e Energia
echo [11/11] Otimizando Rede e Perfil de Energia...
echo Objetivo: Resetar rede (IP/Winsock) e ativar o modo de Alto Desempenho.
netsh winsock reset >nul 2>&1
powercfg -h off >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [OK] >> "%LOGFILE%"

echo.
echo =========================================================
echo  MANUTENCAO CONCLUIDA!
echo  O computador sera desligado em 10 segundos.
echo  Pressione CTRL+C para cancelar o desligamento.
echo =========================================================

timeout /t 10
shutdown /s /t 0 /c "Manutencao completa do Windows 10 finalizada."
