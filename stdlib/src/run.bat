@echo off
..\..\build\carbonc\Debug\carbonc.exe && ..\..\bin\win64\nasm -fwin64 ..\_carbon\build\std.asm && ..\..\bin\win64\GoLink ..\_carbon\build\std.obj /console /entry carbon_main kernel32.dll shell32.dll ucrtbase.dll
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%
..\_carbon\build\std.exe
echo Error level = %errorlevel%