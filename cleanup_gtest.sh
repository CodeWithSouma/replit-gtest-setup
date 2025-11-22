#!/bin/bash

echo "🧹 Starting FULL cleanup — restoring original Replit C++ environment..."

##############################################################
# 1. REMOVE ALL DIRECTORIES CREATED BY SETUP
##############################################################

rm -rf build src tests

##############################################################
# 2. REMOVE GENERATED FILES
##############################################################

rm -f CMakeLists.txt
rm -f .clangd
rm -f cmake_install.cmake
rm -f test_runner main_app libadd_lib.a
rm -f CMakeCache.txt
rm -rf CMakeFiles

##############################################################
# 3. Restore default replit.nix
##############################################################

cat > replit.nix << 'EOF'
{ pkgs }: {
  deps = [
    pkgs.gcc
  ];
}
EOF

##############################################################
# 4. Restore default .replit
##############################################################

cat > .replit << 'EOF'
run = "./main"
compile = "make"
EOF

##############################################################
# 5. Restore default Makefile
##############################################################

cat > Makefile << 'EOF'
CC = g++
CFLAGS = -std=c++17 -Wall
TARGET = main

all: $(TARGET)

$(TARGET): main.cpp
	$(CC) $(CFLAGS) main.cpp -o $(TARGET)

clean:
	rm -f $(TARGET)
EOF

##############################################################
# 6. Restore default main.cpp if missing
##############################################################

if [ ! -f main.cpp ]; then
cat > main.cpp << 'EOF'
#include <iostream>
int main() {
    std::cout << "Hello World!" << std::endl;
    return 0;
}
EOF
fi

##############################################################
# 7. Build & Run
##############################################################

make
./main

echo "🎉 Cleanup complete!"
echo "🧼 Replit C++ environment fully restored!"

