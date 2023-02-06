call %RECIPE_DIR%\bld.bat

if not exist "%SP_DIR%" mkdir "%SP_DIR%"
move "%PREFIX%"\Library\python_packages\mlir_core\mlir "%SP_DIR%"\

if exist "%PREFIX%"\src rmdir /s /q "%PREFIX%"\src
