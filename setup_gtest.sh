#!/bin/bash

echo "🧹 Restoring default Replit C++ environment..."

rm -rf src tests build CMakeFiles CMakeCache.txt cmake_install.cmake
rm -f CMakeLists.txt run_main.sh run_tests.sh run_select.sh
rm -f main main_app test_runner libadd_lib.a run_active.sh
rm -f shell.nix repl-runner.sh replit.nix.backup

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
CC=g++
CFLAGS=-std=c++17 -Wall
all: main
main: main.cpp
	\$(CC) \$(CFLAGS) main.cpp -o main
EOF

# Restore default main.cpp if missing
if [ ! -f main.cpp ]; then
cat > main.cpp << 'EOF'
#include <iostream>
int main() {
  std::cout << "Hello World!" << std::endl;
}
EOF
fi

make
./main

echo "🎉 Cleanup complete! Default environment restored."

