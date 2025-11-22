#!/bin/bash

echo "🚀 Starting GoogleTest Setup with AUTO-CLEAN..."

##############################################################
# 0. AUTO-CLEAN (remove old files)
##############################################################

echo "🧹 Cleaning old conflicting files..."

rm -f main main.cpp Makefile
rm -rf build CMakeFiles CMakeCache.txt cmake_install.cmake
find . -name "main_app*" -delete
find . -name "test_runner*" -delete

echo "✨ Auto-clean complete."

##############################################################
# 1. Create folders
##############################################################

mkdir -p src
mkdir -p tests

##############################################################
# 2. src/add.h
##############################################################

echo "📝 Writing src/add.h"
cat > src/add.h << 'EOF'
#pragma once
int add(int a, int b);
EOF

##############################################################
# 3. src/add.cpp
##############################################################

echo "📝 Writing src/add.cpp"
cat > src/add.cpp << 'EOF'
#include "add.h"

int add(int a, int b) {
    return a + b;
}
EOF

##############################################################
# 4. src/main.cpp
##############################################################

echo "📝 Writing src/main.cpp"
cat > src/main.cpp << 'EOF'
#include "add.h"
#include <iostream>

int main() {
    std::cout << "main_app running! add(2,3) = " << add(2,3) << std::endl;
    return 0;
}
EOF

##############################################################
# 5. tests/test.cpp
##############################################################

echo "📝 Writing tests/test.cpp"
cat > tests/test.cpp << 'EOF'
#include <gtest/gtest.h>
#include "add.h"

TEST(AdditionTest, Basic) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-1, 1), 0);
    EXPECT_EQ(add(0, 0), 0);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
EOF

##############################################################
# 6. CMakeLists.txt
##############################################################

echo "🛠 Writing CMakeLists.txt"
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(ReplitGTestProject)

set(CMAKE_CXX_STANDARD 17)

add_library(add_lib src/add.cpp)

add_executable(main_app src/main.cpp)
target_link_libraries(main_app add_lib)

add_executable(test_runner tests/test.cpp)
target_include_directories(test_runner PRIVATE src)

find_package(GTest REQUIRED)

target_link_libraries(test_runner
    add_lib
    GTest::gtest
    GTest::gtest_main
    pthread
)
EOF

##############################################################
# 7. replit.nix
##############################################################

echo "🛠 Writing replit.nix"
cat > replit.nix << 'EOF'
{ pkgs }: {
  deps = [
    pkgs.gcc
    pkgs.cmake
    pkgs.gtest
    pkgs.pkg-config
  ];
}
EOF

##############################################################
# 8. .clangd
##############################################################

echo "🧠 Writing .clangd"
cat > .clangd << 'EOF'
CompileFlags:
  Add:
    - -I/usr/include
    - -I/nix/store
EOF

##############################################################
# 9. SMART .replit (FIXED REPL_ACTIVE_FILE)
##############################################################

echo "⚙ Writing smart .replit"
cat > .replit << 'EOF'
run = """
set -e

ACTIVE="$REPL_ACTIVE_FILE"
echo "🟦 Active file: $ACTIVE"

# Run tests if test.cpp is active
if [[ "$ACTIVE" == *"tests/test.cpp"* ]]; then
  echo "🧪 Running GoogleTests..."
  if [ ! -f build/Makefile ]; then
    rm -rf build && mkdir build && cd build && cmake ..
  else
    cd build
  fi
  make test_runner
  echo "🟩 Running test_runner..."
  ./test_runner
  exit 0
fi

# Run main_app if main file active
if [[ "$ACTIVE" == *"src/main.cpp"* ]]; then
  echo "▶ Running main_app..."
  if [ ! -f build/Makefile ]; then
    rm -rf build && mkdir build && cd build && cmake ..
  else
    cd build
  fi
  make main_app
  ./main_app
  exit 0
fi

# Fallback → run main_app
echo "ℹ Defaulting to main_app..."
if [ ! -f build/Makefile ]; then
  rm -rf build && mkdir build && cd build && cmake ..
else
  cd build
fi
make main_app
./main_app
"""
EOF

##############################################################
# 10. Build
##############################################################

echo "🔨 Running initial build..."

rm -rf build
mkdir build
cd build
cmake ..
make

echo "🎉 GoogleTest installation complete!"
echo "➡ Smart Run Button ENABLED"
echo "➡ Open test.cpp → Run → GoogleTests"
echo "➡ Open main.cpp → Run → main_app"

