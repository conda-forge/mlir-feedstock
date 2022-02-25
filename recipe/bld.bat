@echo on
mkdir build
cd build

cmake -GNinja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -DLLVM_BUILD_TOOLS=ON ^
  -DLLVM_BUILD_UTILS=ON ^
  ..\mlir
if %ERRORLEVEL% neq 0 exit 1

ninja -j%CPU_COUNT%
if %ERRORLEVEL% neq 0 exit 1
