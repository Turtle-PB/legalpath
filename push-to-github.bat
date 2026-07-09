@echo off
REM ═══════════════════════════════════════════════
REM LegalPath — Push to GitHub
REM © 2025 Paul Adcock — Patent Pending
REM ═══════════════════════════════════════════════
echo.
echo  ========================================================
echo   LegalPath — Push to GitHub
echo  ========================================================
echo.
echo  This will create a GitHub repository and push LegalPath.
echo.
echo  Steps:
echo   1. GitHub CLI will try to create a public repo
echo   2. If it fails, create the repo manually at:
echo      https://github.com/new
echo      Name: legalpath
echo      Description: LegalPath - Self-Contained Legal Case Builder PWA
echo      Set to: Public
echo      Do NOT add README/gitignore (already created)
echo   3. Run this script again to push
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
echo  (If prompted, open the URL and enter the code)
gh auth login --hostname github.com --git-protocol https --web --scopes repo

echo.
echo  Creating repository...
gh repo create legalpath --public --source=. --push --description "LegalPath - Self-Contained Legal Case Builder PWA. Document analysis engine, 33+ legal document templates, ADA/ERISA/SSDI guidance, case law database, bad company index, boycott poster generator, immigrant rights resources. (c) 2025 Paul Adcock - Patent Pending"

if %errorlevel% neq 0 (
  echo.
  echo  ========================================================
  echo   Could not create repo automatically.
  echo  ========================================================
  echo  Please create the repo manually:
  echo  1. Go to: https://github.com/new
  echo  2. Repository name: legalpath
  echo  3. Set to Public
  echo  4. Do NOT add README or .gitignore
  echo  5. Click "Create repository"
  echo  6. Run this script again
  echo  ========================================================
  echo.
  pause
  exit /b
)

echo.
echo  ========================================================
echo   SUCCESS! LegalPath is now on GitHub!
echo  ========================================================
echo  Your repo: https://github.com/%USERNAME%/legalpath
echo.
echo  To enable GitHub Pages:
echo  1. Go to: https://github.com/%USERNAME%/legalpath/settings/pages
echo  2. Source: Deploy from branch
echo  3. Branch: main / (root)
echo  4. Save
echo  5. Your site: https://%USERNAME%.github.io/legalpath/
echo  ========================================================
echo.
pause
