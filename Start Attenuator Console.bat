@echo off
rem Attenuator Console launcher - opens index.html in Chrome or Edge (Web Serial required).
rem Uses --app mode: a clean window without tabs/address bar.
setlocal
set "APP=%~dp0index.html"
set "URL=file:///%APP:\=/%"

for %%B in (
  "%ProgramFiles%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
  "%LocalAppData%\Google\Chrome\Application\chrome.exe"
  "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
  "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
) do (
  if exist %%B (
    start "" %%B --app="%URL%"
    exit /b 0
  )
)

rem Fallback: Edge via its registered app alias
start "" msedge --app="%URL%"
if errorlevel 1 (
  echo Chrome or Edge was not found. Please open index.html with Google Chrome or Microsoft Edge.
  pause
)
endlocal
