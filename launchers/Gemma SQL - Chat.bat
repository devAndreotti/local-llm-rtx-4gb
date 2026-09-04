@echo off
title Gemma SQL - Assistente de SQL (Ollama / CUDA)
color 0E
echo ============================================================
echo    Gemma SQL - gera queries SQL corretas (deterministico)
echo    Base: E4B  ^|  Modelo: gemma-sql
echo    Descreva as tabelas e o que voce quer.
echo ============================================================
echo.
start "" "%LOCALAPPDATA%\Programs\Ollama\ollama app.exe"
:wait_server
"%LOCALAPPDATA%\Programs\Ollama\ollama.exe" list >nul 2>&1
if errorlevel 1 ( ping -n 2 127.0.0.1 >nul & goto wait_server )
echo  Dica: /bye para sair.
echo.
"%LOCALAPPDATA%\Programs\Ollama\ollama.exe" run gemma-sql --think=false
pause >nul
