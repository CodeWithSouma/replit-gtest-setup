#!/bin/bash

echo "🧹 Restoring default Replit C++ environment..."

# Remove GTest + CMake structure
rm -rf build src tests
rm -f CMakeLists.txt .clangd run_main.sh run_tests.sh run_select.sh
rm -rf CMakeFiles CMakeCache.txt cmake_install.cmake
rm -f main_app test_runner libadd_lib.a

# Restore default .replit
cat > .replit << 'EOF'
run = "./main"
compile = "make"
EOF

# Restore default replit.nix
cat > replit.nix << 'EOF'
{ pkgs }: {
  deps = [ pkgs.gcc ];
}
EOF

# Restore default Makefile
cat > Makefile << 'EOF'
CC = g++
CFLAGS = -std=c++17 -Wall
TARGET = main

all: \$(TARGET)

\$(TARGET): main.cpp
	\$(CC) \$(CFLAGS) main.cpp -o \$(TARGET)

clean:
	rm -f \$(TARGET)
EOF

# Restore main.cpp if missing
if [ ! -f main.cpp ]; then
cat > main.cpp << 'EOF'
#include <iostream>
int main() {
    std::cout << "Hello World!" << std::endl;
    return 0;
}
EOF
fi

make
./main

echo "🎉 Cleanup complete! Default C++ project restored."

