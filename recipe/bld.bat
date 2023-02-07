if exist build\CMakeCache.txt (
  sed -i.bak "/^_Python3_INTERPRETER_PROPERTIES/d" build\CMakeCache.txt
)

mkdir build
cd build

if "%PKG_NAME%" == "mlir-python-bindings" (
  set MLIR_ENABLE_BINDINGS_PYTHON=ON
) else (
  set MLIR_ENABLE_BINDINGS_PYTHON=OFF
)

cmake -GNinja ^
  -DCMAKE_BUILD_TYPE=Release ^
  -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
  -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
  -DLLVM_USE_INTEL_JITEVENTS=1 ^
  -DLLVM_BUILD_TOOLS=ON ^
  -DLLVM_BUILD_UTILS=ON ^
  -DMLIR_ENABLE_BINDINGS_PYTHON=%MLIR_ENABLE_BINDINGS_PYTHON% ^
  -DPython3_EXECUTABLE="%PYTHON%" ^
  ..\mlir
if %ERRORLEVEL% neq 0 exit 1

ninja -j%CPU_COUNT%
if %ERRORLEVEL% neq 0 exit 1
