@echo off
cd /D %~dp0

:CheckOS
IF EXIST "%PROGRAMFILES(X86)%" (GOTO 64BIT) ELSE (GOTO 32BIT)

:64BIT
SET ProgramFilesDir=%PROGRAMFILES(X86)%
GOTO END

:32BIT
SET ProgramFilesDir=%PROGRAMFILES%
GOTO END

:END
del "%cd%\bin\SecureRunAs.exe" /q /s
"%ProgramFilesDir%\AutoIt3\Aut2Exe\Aut2exe.exe" /in "%cd%\src\SecureRunAs.au3" /out "%cd%\bin\SecureRunAs.exe" /icon "%cd%\src\104.ico" /x86 /console /comp 4

