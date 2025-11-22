#!/bin/bash

echo "🚀 Starting GoogleTest Setup with AUTO-CLEAN..."

##############################################################
# 0. AUTO-CLEAN (Fix stale builds, default files, conflicts)
##############################################################

echo "🧹 Cleaning old conflicting files..."

# Remove default Replit C++ project files
rm -f main.cpp main Makefile

# Remove old cmake leftovers
rm -rf build CMakeFiles CMakeCache.txt cmake_install.cmake

# Remove old executables
find . -name "main_app" -delete
find . -name "main_appe" -delete
find . -name "main_app*" -delete
find . -name "test_runner" -delete

echo "✨ Auto-clean complete."

##############################################################
# 1. Create structure
##############################################################

mkdir -p src
mkdir -p tests

##############################################################
# 2. Create tests/test.cpp
##############################################################

echo "📝 Writing tests/test.cpp"
cat > tests/test.cpp << 'EOF'
#include <gtest/gtest.h>

int add(int a, int b);

TEST(AdditionTest, Basic) {
    EXPECT_EQ(add(2, 3), 5);
}

int main(int argc, char **argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
EOF

##############################################################
# 3. Create src/main.cpp
##############################################################

echo "📝 Writing src/main.cpp"
cat > src/main.cpp << 'EOF'
int add(int a, int b) {
    return a + b;
}

#include <iostream>
int main() {
    std::cout << "main_app running! add(2,3)=" << add(2,3) << std::endl;
    return 0;
}
EOF

##############################################################
# 4. Create CMakeLists.txt
##############################################################

echo "🛠 Writing CMakeLists.txt"
cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(ReplitGTestProject)

set(CMAKE_CXX_STANDARD 17)

add_executable(main_app src/main.cpp)

add_executable(test_runner tests/test.cpp)

find_package(GTest REQUIRED)

target_link_libraries(test_runner
    GTest::gtest
    GTest::gtest_main
    pthread
)
EOF

##############################################################
# 5. Create replit.nix
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
# 6. Create .clangd
##############################################################

echo "🧠 Writing .clangd"
cat > .clangd << 'EOF'
CompileFlags:
  Add:
    - -I/usr/include
    - -I/nix/store
EOF

##############################################################
# 7. Create .replit
##############################################################

echo "⚙ Writing .replit"
cat > .replit << 'EOF'
run = """
if [ ! -f build/Makefile ]; then
  rm -rf build
  mkdir build
  cd build
  cmake ..
else
  cd build
fi

make main_app
./main_app
"""

[commands]

run_main = """
if [ ! -f build/Makefile ]; then
  rm -rf build
  mkdir build
  cd build
  cmake ..
else
  cd build
fi

make main_app
./main_app
"""

run_tests = """
if [ ! -f build/Makefile ]; then
  rm -rf build
  mkdir build
  cd build
  cmake ..
else
  cd build
fi

make test_runner
./test_runner
"""
EOF

##############################################################
# 8. Initial CMake Build
##############################################################

echo "🔨 Running initial build..."

rm -rf build
mkdir build
cd build
cmake ..
make

echo "🎉 GoogleTest installation complete!"
echo "➡ Run button executes main_app"
echo "➡ run_tests runs your GoogleTests"
echo "➡ run_main runs main_app"

