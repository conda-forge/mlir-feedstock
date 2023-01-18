cd build
ninja install

if "%PKG_NAME%" == "mlir-python-bindings" (
    if not exist "%SP_DIR%" mkdir "%SP_DIR%"
    move "%PREFIX%"\Library\python_packages\mlir_core\mlir "%SP_DIR%"\
)

if exist "%PREFIX%"\Library\python_packages rmdir /s /q "%PREFIX%"\Library\python_packages
if exist "%PREFIX%"\src rmdir /s /q "%PREFIX%"\src
