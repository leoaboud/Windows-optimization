@echo off
:: ============================================================
::  MANUTENCAO AUTOMATIZADA - WINDOWS 11 + HDD
:: ============================================================

:: [AUTO-ELEVAÇÃO] Solicita permissão de administrador automaticamente [cite: 1]
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%0' -Verb RunAs"
    exit /b
)

title Manutencao Automatica - Windows 11 (HDD Edition)
color 0A

set LOGFILE=%SystemDrive%\manutencao_hdd_log.txt
echo Manutencao iniciada em: %date% %time% > "%LOGFILE%"

echo =========================================================
echo  INICIANDO WIN PRO... POR FAVOR, AGUARDE.
echo =========================================================

:: [1/12] Arquivos Temporários
echo [1/12] Limpando arquivos temporarios...
echo Objetivo: Liberar espaco e reduzir a fragmentacao causada por arquivos inuteis[cite: 7].
del /s /f /q "%TEMP%\*.*" >nul 2>&1
rd /s /q "%TEMP%" >nul 2>&1
md "%TEMP%" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
rd /s /q "C:\Windows\Temp" >nul 2>&1
md "C:\Windows\Temp" >nul 2>&1
echo [OK] >> "%LOGFILE%" [cite: 8]

:: [2/12] Prefetch (Essencial para HDD)
echo [2/12] Limpando cache de inicializacao (Prefetch)...
echo Objetivo: O Windows criara um novo mapa de carregamento mais eficiente para o seu disco.
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [3/12] DNS
echo [3/12] Limpando cache de DNS...
echo Objetivo: Resolver falhas de conexao e melhorar o tempo de resposta da rede[cite: 10].
ipconfig /flushdns >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [4/12] Miniaturas
echo [4/12] Resetando cache de miniaturas...
echo Objetivo: Corrigir lentidao ao abrir pastas com muitas fotos ou videos[cite: 11].
taskkill /f /im explorer.exe >nul 2>&1
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
start explorer.exe
echo [OK] >> "%LOGFILE%"

:: [5/12] Cleanmgr
echo [5/12] Executando Limpeza de Disco...
echo Objetivo: Remocao profunda de arquivos residuais do sistema[cite: 12].
cleanmgr /sagerun:1
echo [OK] >> "%LOGFILE%"

:: [6/12] WinSxS
echo [6/12] Limpando base de componentes do Windows Update...
echo Objetivo: Reduzir o tamanho da pasta Windows e facilitar a leitura do disco[cite: 13].
Dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
echo [OK] >> "%LOGFILE%" [cite: 14]

:: [7/12] MS Store
echo [7/12] Resetando cache da Microsoft Store...
echo Objetivo: Garantir que a loja e seus apps funcionem sem erros[cite: 15].
wsreset.exe
echo [OK] >> "%LOGFILE%"

:: [8/12] Integridade SFC + DISM
echo [8/12] Reparando arquivos do sistema...
echo Objetivo: Corrigir falhas que podem causar travamentos tipicos de HDDs lentos[cite: 16].
DISM /Online /Cleanup-Image /RestoreHealth
sfc /scannow
echo [OK] >> "%LOGFILE%"

:: [9/12] DESFRAGMENTAÇÃO (Crucial para HDD)
echo [9/12] DESFRAGMENTANDO O DISCO... (Isso pode demorar)
echo Objetivo: Organizar os arquivos fisicamente para que o HDD trabalhe com menos esforco.
defrag C: /U /V
echo [OK] >> "%LOGFILE%"

:: [10/12] Atualizacoes Winget
echo [10/12] Atualizando aplicativos instalados...
echo Objetivo: Manter softwares otimizados e seguros[cite: 25, 28].
winget upgrade --all --silent --include-unknown >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [11/12] Logs de Eventos
echo [11/12] Limpando logs de eventos...
echo Objetivo: Remover registros desnecessarios acumulados no disco[cite: 20].
wevtutil cl Application >nul 2>&1
wevtutil cl System >nul 2>&1
wevtutil cl Security >nul 2>&1
echo [OK] >> "%LOGFILE%"

:: [12/12] Rede e Energia
echo [12/12] Otimizando Rede e Ativando Hibernacao...
echo Objetivo: Resetar rede e permitir que o HDD inicie o Windows mais rapido via Hibernacao[cite: 22, 23].
netsh winsock reset >nul 2>&1
powercfg -h on >nul 2>&1
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul 2>&1
echo [OK] >> "%LOGFILE%"

echo.
echo =========================================================
echo  MANUTENCAO CONCLUIDA!
echo  O PC desligara em 10s. Pressione CTRL+C para cancelar.
echo =========================================================

timeout /t 10 [cite: 30]
shutdown /s /t 0 /c "Manutencao concluida no HDD." [cite: 30]
