@echo off
title Gemma Resumo - Resumidor de textos (Ollama / CUDA)
color 0B
echo ============================================================
echo    Gemma Resumo - resume textos longos (visao geral + bullets)
echo    Base: E2B (contexto 128K!)  ^|  Modelo: gemma-resumo
echo    Cole o texto e peca o resumo.
echo ============================================================
echo.
start "" "%LOCALAPPDATA%\Programs\Ollama\ollama app.exe"
:wait_server
"%LOCALAPPDATA%\Programs\Ollama\ollama.exe" list >nul 2>&1
if errorlevel 1 ( ping -n 2 127.0.0.1 >nul & goto wait_server )
echo  Dica: /bye para sair.
echo.
"%LOCALAPPDATA%\Programs\Ollama\ollama.exe" run gemma-resumo --think=false
pause >nul
