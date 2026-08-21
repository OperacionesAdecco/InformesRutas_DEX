@echo off
chcp 65001 > nul
title PUBLICANDO INFORME SEMANAL DEX EN GITHUB

echo ================================================================
echo PUBLICANDO INFORME SEMANAL DEX EN GITHUB
echo ================================================================

cd /d "%~dp0"

where git >nul 2>nul
if errorlevel 1 (
    echo.
    echo ERROR: Git no esta instalado o no esta agregado al PATH.
    pause
    exit /b 1
)

if not exist ".git" (
    echo.
    echo Inicializando repositorio local...
    git init
    git branch -M main
    git remote add origin https://github.com/OperacionesAdecco/InformesRutas_DEX.git
) else (
    git remote set-url origin https://github.com/OperacionesAdecco/InformesRutas_DEX.git
)

echo.
echo Sincronizando primero con GitHub...
git fetch origin main

git pull origin main --rebase --autostash
if errorlevel 1 (
    echo.
    echo ERROR: No se pudo sincronizar con GitHub.
    echo Ejecuta: git rebase --abort
    pause
    exit /b 1
)

echo.
echo Preparando archivos...

if not exist ".gitignore" (
    echo ~$*.xlsx>.gitignore
    echo __pycache__/>>.gitignore
    echo *.pyc>>.gitignore
)

git add -A

git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Actualizacion automatica Informe Semanal DEX"
    if errorlevel 1 (
        echo.
        echo ERROR: No se pudo crear el commit.
        pause
        exit /b 1
    )
) else (
    echo No hay cambios nuevos para confirmar.
)

echo.
echo Subiendo archivos a GitHub...
git push -u origin main

if errorlevel 1 (
    echo.
    echo ERROR: No se pudo subir la informacion a GitHub.
    pause
    exit /b 1
)

echo.
echo ================================================================
echo PUBLICACION COMPLETADA CORRECTAMENTE
echo ================================================================
echo.
echo Pagina principal:
echo https://OperacionesAdecco.github.io/InformesRutas_DEX/
echo.
pause