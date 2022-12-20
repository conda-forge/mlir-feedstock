cd build
ninja install

if "%PKG_NAME%" == "mlir" (
    rmdir /s /q "%PREFIX%"\\python_packages
    rmdir /s /q "%PREFIX%"\\src
)
