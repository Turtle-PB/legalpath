@echo off
REM ═══════════════════════════════════════════════
REM LegalPath — Deploy to Surge.sh (Free HTTPS)
REM © 2025 Paul Adcock — Patent Pending
REM ═══════════════════════════════════════════════
echo.
echo  ========================================================
echo   LegalPath — Deploy to Surge.sh (Free HTTPS Hosting)
echo  ========================================================
echo.
echo  Surge.sh provides free HTTPS hosting with no account
echo  required — just an email and password (creates instant account)
echo.
echo  Press any key to start...
pause >nul

echo.
echo  Deploying LegalPath to Surge.sh...
echo  (Enter any email and password — this creates your account)
echo.
call npx surge . legalpath-app.surge.sh

echo.
echo  ========================================================
echo   If successful, your site is live at:
echo   https://legalpath-app.surge.sh
echo   
echo   Or whatever domain you chose during deploy.
echo  ========================================================
echo.
pause
