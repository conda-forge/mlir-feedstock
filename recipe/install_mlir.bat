cd build
ninja install

if exist "%PREFIX%"\Library\python_packages rmdir /s /q "%PREFIX%"\Library\python_packages
if exist "%PREFIX%"\src rmdir /s /q "%PREFIX%"\src
