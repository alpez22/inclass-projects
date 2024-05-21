#include <iostream>
#include <bitset>
#include <vector>
#include "sparrow.h"

int main() {
    std::vector<std::bitset<32>> vector1{std::bitset<32>("11100000000001100000000000100010")};
    std::vector<std::bitset<32>> vector2{std::bitset<32>("01110000000001111000000000100001")};

    auto [resultAndVec, isValid] = sparrow::warmup::BitAnd(vector1, vector2);

    if(isValid){
        std::cout << sparrow::warmup::CountBits(resultAndVec);
    }else{
        //should be valid
    }

    return 0;
}
