@echo off
set refinstalldir=%LOCALAPPDATA%\wsltty
set installdir=C:\Users\math0\AppData\Local\wsltty
set refconfigdir=%APPDATA%\wsltty
set configdir=C:\Users\math0\AppData\Roaming\wsltty
@echo off

if "%installdir%" == "" set installdir=%LOCALAPPDATA%\wsltty
if "%configdir%" == "" set configdir=%APPDATA%\wsltty


if "%1"=="/U" goto remove
if "%1"=="/u" goto remove


:add
rem add to Explorer context menu

set userdirname=HKEY_CURRENT_USER\Software\Classes\Directory\shell
set userdirpane=HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell

rem WSL in Mintty
set label=WSL in Mintty
rem set here=in this directory
set here=Here

rem WSL icon
set icon=%LOCALAPPDATA%\lxss\bash.ico

rem WSL target shell
set shell=/bin/bash

rem Mintty invocation
set cmd=%installdir%\bin\mintty.exe
set cset=-o Locale=C -o Charset=UTF-8
set opts=--wsl -h err
set arg=/bin/wslbridge -t %shell%
set target0=\"%cmd%\" %opts% %cset% --configdir \"%configdir%\" -i \"%icon%\" %arg%
rem set target1=\"%cmd%\" %opts% %cset% --configdir \"%configdir%\" -i \"%icon%\" /bin/dash -c \"cd '%%1'; exec %arg%\"
set target1=\"%cmd%\" %opts% %cset% --configdir \"%configdir%\" -i \"%icon%\" --dir \"%%1\" %arg%

rem Registry entries
reg add "%userdirname%\wsltty" /d "%label% %here%" /f
reg add "%userdirname%\wsltty" /v Icon /d "%icon%" /f
reg add "%userdirname%\wsltty\command" /d "%target1%" /f
reg add "%userdirpane%\wsltty" /d "%label% %here%" /f
reg add "%userdirpane%\wsltty" /v Icon /d "%icon%" /f
reg add "%userdirpane%\wsltty\command" /d "%target0%" /f

goto end


:remove
rem remove from Explorer context menu

rem delete Explorer context menu
set userdirname=HKEY_CURRENT_USER\Software\Classes\Directory\shell
set userdirpane=HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell

reg delete "%userdirname%\wsltty" /f
reg delete "%userdirpane%\wsltty" /f


:end
