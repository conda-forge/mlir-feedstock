cd build
ninja install

if "%PKG_NAME%" == "mlir-python-bindings" (
    if not exist "%SP_DIR%" mkdir "%SP_DIR%"
    move "%PREFIX%"\\python_packages\\mlir_core\\mlir "%SP_DIR%"\\
)

echo "Listing of PREFIX:"
dir "%PREFIX%"
echo "Removing PREFIX/python_packages and PREFIX/src"
if exist "%PREFIX%"\\python_packages rmdir /s /q "%PREFIX%"\\python_packages
if exist "%PREFIX%"\\src rmdir /s /q "%PREFIX%"\\src
