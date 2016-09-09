del "Audacious*.exe"
for %%a in (Audacious.nsi) do "C:\Program Files (x86)\NSIS\makensis.exe" /DDEV /DDEV2 %%a
pause
for %%a in (Audacious.nsi) do "C:\Program Files\NSIS\makensis.exe" /DDEV /DDEV2 %%a
pause
