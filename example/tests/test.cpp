#include <gtest/gtest.h>
TEST(X,Y){EXPECT_EQ(1,1);} int main(int a,char**b){testing::InitGoogleTest(&a,b);return RUN_ALL_TESTS();}