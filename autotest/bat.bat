@echo off
for /f %%i in ('dir testcode /b') do (
	@echo "%%i"
)
pause