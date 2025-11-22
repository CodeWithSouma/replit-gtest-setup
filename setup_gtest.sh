#!/bin/bash

echo "🔧 Starting Safe GoogleTest Setup for Replit..."

#########################################
# 1. Create directories (safe)
#########################################

if [ ! -d "src" ]; then
  echo "📁 Creating src/ directory"
  mkdir -p src
else
  echo "✔ src/ directory already exists"
fi

if [ ! -d "tests" ]; then
  echo "📁 Creating tests/ directory"
  mkdir -p tests
else
  echo "✔ tests/ directory already exists"
fi

#########################################
# 2. Create/override test.cpp
#########################################

echo "📝 Writing sample GoogleTest file → tests/test.cpp"
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

#########################################
# 3. Create main.cpp ONLY IF missing
#########################################

if [ ! -f "src/main.cpp" ]; then
  echo "📝 Creating src/main.cpp (since it doesn't exist)"

cat > src/main.cpp << 'EOF'
int add(int a, int b) {
    return a + b;
}

int main() {
    return 0;
}
EOF

else
  echo "✔ src/main.cpp exists — using your existing code"
fi

#########################################
# 4. Write CMakeLists.txt
#########################################

echo "🛠 Updating CMakeLists.txt"

cat > CMakeLists.txt << 'EOF'
cmake_minimum_required(VERSION 3.10)
project(GTestProject)

set(CMAKE_CXX_STANDARD 17)

add_executable(test_runner
    src/main.cpp
    tests/test.cpp
)

find_package(GTest REQUIRED)
target_link_libraries(test_runner
    GTest::gtest
    GTest::gtest_main
    pthread
)
EOF

#########################################
# 5. Write replit.nix
#########################################

echo "🛠 Writing replit.nix (GTest installation)"

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

#########################################
# 6. Write .replit config
#########################################

echo "⚙ Writing .replit config"

cat > .replit << 'EOF'
run = """
if [ ! -d build ]; then 
  mkdir build && cd build && cmake ..; 
fi
cd build && make && ./test_runner
"""

[commands]

run_tests = """
if [ ! -d build ]; then 
  mkdir build && cd build && cmake ..; 
fi
cd build && make && ./test_runner
"""

run_main = "g++ src/main.cpp -o main && ./main"
EOF

#########################################
# 7. Write .clangd (fix IntelliSense)
#########################################

echo "✨ Writing .clangd to fix IntelliSense"

cat > .clangd << 'EOF'
CompileFlags:
  Add:
    - -I/usr/include
    - -I/nix/store
EOF

#########################################
# 8. Run CMake initialization
#########################################

echo "🔨 Initializing CMake..."

mkdir -p build
cd build
cmake ..

echo "🎉 GoogleTest Setup Complete!"
echo "➡ Click RUN to execute tests"
echo "➡ Use 'run_main' in Commands to run main.cpp"

