del "Audacious*.exe"
for %%a in (Audacious.nsi) do "C:\Program Files (x86)\NSIS\makensis.exe" /DTEST_WITHOUTFILES %%a
pause
for %%a in (Audacious.nsi) do "C:\Program Files\NSIS\makensis.exe" /DTEST_WITHOUTFILES %%a
pause
