@echo off
REM ═══════════════════════════════════════════════
REM LegalPath — One-Click Deploy to Netlify
REM © 2025 Paul Adcock — Patent Pending
REM ═══════════════════════════════════════════════
echo.
echo  ========================================================
echo   LegalPath — Deploy to Netlify (Free HTTPS Hosting)
echo  ========================================================
echo.
echo  This will publish LegalPath to a free HTTPS URL that you
echo  can use on your phone, share with others, or submit to
echo  app stores.
echo.
echo  Steps:
echo   1. A browser window will open
echo   2. Create a free Netlify account (email or Google)
echo   3. Authorize Netlify CLI
echo   4. Your site goes live instantly
echo.
echo  Press any key to start...
pause >nul

echo.
echo  Installing Netlify CLI...
call npm install -g netlify-cli

echo.
echo  Deploying LegalPath to Netlify...
echo  (A browser window will open for authentication)
echo.
call npx netlify deploy --dir=. --prod

echo.
echo  ========================================================
echo   If successful, your URL will appear above!
echo   Copy that URL and use it on your phone.
echo  ========================================================
echo.
pause
