#!/bin/bash

echo "🧹 Restoring default Replit C++ environment..."

rm -rf build src tests
rm -f CMakeLists.txt .clangd run_main.sh run_tests.sh
rm -rf CMakeFiles CMakeCache.txt cmake_install.cmake

# Restore default .replit
cat > .replit << 'EOF'
run = "./main"
compile = "make"
EOF

# Restore default Makefile
cat > Makefile << 'EOF'
CC=g++
CFLAGS=-std=c++17 -Wall
all: main
main: main.cpp
	\$(CC) \$(CFLAGS) main.cpp -o main
EOF

# Restore default replit.nix
cat > replit.nix << 'EOF'
{ pkgs }: {
  deps = [ pkgs.gcc ];
}
EOF

# Restore main.cpp if missing
if [ ! -f main.cpp ]; then
cat > main.cpp << 'EOF'
#include <iostream>
int main() {
    std::cout<<"Hello World!"<<std::endl;
}
EOF
fi

make
./main

echo "🎉 Cleanup complete!"

