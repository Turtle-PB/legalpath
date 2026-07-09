@echo off
REM ═══════════════════════════════════════════════
REM LegalPath — One-Click Deploy to GitHub Pages
REM © 2025 Paul Adcock — Patent Pending
REM ═══════════════════════════════════════════════
echo.
echo  ========================================================
echo   LegalPath — Deploy to GitHub Pages (Free HTTPS Hosting)
echo  ========================================================
echo.
echo  This will publish LegalPath to GitHub Pages.
echo  Your site URL will be: https://[username].github.io/legalpath/
echo.
echo  Prerequisites:
echo   - You need a GitHub account
echo   - GitHub CLI will open a browser to authenticate
echo.
echo  Press any key to start...
pause >nul

echo.
echo  Checking GitHub CLI...
where gh >nul 2>&1
if %errorlevel% neq 0 (
  echo  Installing GitHub CLI...
  winget install --id GitHub.cli --accept-source-agreements --accept-package-agreements
)

echo.
echo  Authenticating with GitHub...
echo  (A browser window will open — enter the code shown here)
echo.
gh auth login --hostname github.com --git-protocol https --web

echo.
echo  Creating GitHub repository...
gh repo create legalpath --public --source=. --push --description "LegalPath — Case Builder System & Analysis Engine. © 2025 Paul Adcock — Patent Pending"

echo.
echo  Enabling GitHub Pages...
echo  Go to: https://github.com/%USERNAME%/legalpath/settings/pages
echo  Set Source to: Deploy from branch → main → /(root)
echo  Your site will be live in 1-5 minutes at:
echo  https://[your-username].github.io/legalpath/
echo.
echo  ========================================================
echo   Done! Check the URL above.
echo  ========================================================
echo.
pause
