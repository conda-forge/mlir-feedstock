cd build
ninja install

echo "PKG_NAME=%PKG_NAME%"
if "%PKG_NAME%" == "mlir-python-bindings" (
    echo "handling mlir-python-bindings SP_DIR=%SP_DIR%"
    if not exist "%SP_DIR%" mkdir "%SP_DIR%"
    move "%PREFIX%"\Library\python_packages\mlir_core\mlir "%SP_DIR%"\
)

echo "Listing of PREFIX:"
dir "%PREFIX%"
echo "Removing PREFIX/python_packages and PREFIX/src"
if exist "%PREFIX%"\Library\python_packages rmdir /s /q "%PREFIX%"\Library\python_packages
if exist "%PREFIX%"\src rmdir /s /q "%PREFIX%"\src
