cd build
ninja install

if "%PKG_NAME%" == "mlir-python-bindings" (
    if not exist "%SP_DIR%" mkdir "%SP_DIR%"
    move "%PREFIX%"\\python_packages\\mlir_core\\mlir "%SP_DIR%"\\
)

rmdir /s /q "%PREFIX%"\\python_packages
rmdir /s /q "%PREFIX%"\\src
