#!/bin/bash

echo "🚀 Starting GoogleTest Setup (Menu-Based Runner)..."

##############################
# 0. CLEAN OLD FILES
##############################

echo "🧹 Cleaning environment..."
rm -f main main.cpp Makefile run_main.sh run_tests.sh run_select.sh
rm -rf build CMakeFiles CMakeCache.txt cmake_install.cmake
rm -rf src tests

##############################
# CREATE DIRECTORIES
##############################

mkdir -p src
mkdir -p tests

##############################
# src/add.h
##############################

echo "📝 Writing src/add.h"
cat > src/add.h << 'EOF'
#pragma once
int add(int a, int b);
EOF

##############################
# src/add.cpp
##############################

echo "📝 Writing src/add.cpp"
cat > src/add.cpp << 'EOF'
#include "add.h"

int add(int a, int b) {
    return a + b;
}
EOF

##############################
# src/main.cpp
##############################

echo "📝 Writing src/main.cpp"
cat > src/main.cpp << 'EOF'
#include "add.h"
#include <iostream>

int main() {
    std::cout << "main_app running! add(2,3) = " << add(2,3) << std::endl;
    return 0;
}
EOF

##############################
# tests/test.cpp
##############################

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

##############################
# CMakeLists.txt
##############################

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

##############################
# replit.nix
##############################

echo "🛠 Writing replit.nix"
cat > replit.nix << 'EOF'
{ pkgs }: {
  deps = [
    pkgs.gcc
    pkgs.cmake
    pkgs.gtest
  ];
}
EOF

##############################
# run_main.sh
##############################

echo "🟩 Creating run_main.sh"
cat > run_main.sh << 'EOF'
#!/bin/bash

echo "▶ Running main_app..."

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
EOF
chmod +x run_main.sh

##############################
# run_tests.sh
##############################

echo "🧪 Creating run_tests.sh"
cat > run_tests.sh << 'EOF'
#!/bin/bash

echo "🧪 Running GoogleTests..."

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
EOF
chmod +x run_tests.sh

##############################
# run_select.sh (Fancy Menu)
##############################

echo "🧭 Creating run_select.sh (menu runner)"
cat > run_select.sh << 'EOF'
#!/bin/bash

while true; do
  echo "========================================="
  echo "🔥 Replit GTest Runner — Choose an action"
  echo "========================================="
  echo "1) ▶ Run main_app"
  echo "2) 🧪 Run GoogleTests"
  echo "3) ❌ Exit"
  echo "========================================="
  read -p "Enter choice (1/2/3): " choice

  case "$choice" in
    1)
      bash ./run_main.sh
      break
      ;;
    2)
      bash ./run_tests.sh
      break
      ;;
    3)
      echo "👋 Exiting runner."
      exit 0
      ;;
    *)
      echo "⚠ Invalid choice. Please enter 1, 2, or 3."
      ;;
  esac
done
EOF
chmod +x run_select.sh

##############################
# .replit
##############################

echo "⚙ Writing .replit"
cat > .replit << 'EOF'
run = "bash -ic './run_select.sh'"

[commands]
run_main = "bash -ic './run_main.sh'"
run_tests = "bash -ic './run_tests.sh'"
EOF

##############################
# INITIAL BUILD
##############################

echo "🔨 Running initial build..."
rm -rf build
mkdir build
cd build
cmake ..
make

echo "🎉 GoogleTest setup complete!"
echo "➡ Click RUN to see menu in TERMINAL"
echo "➡ Choose 1 for main_app, 2 for tests"

