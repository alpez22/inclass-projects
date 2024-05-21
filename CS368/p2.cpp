#include <iostream>
#include <vector>
#include <bitset>
#include "sparrow.h"

int main() {
    sparrow::NullableInts nints1{.nums={20,999,40,60}, .valid={std::bitset<32>("00000000000000000000000000001101")}};
    sparrow::NullableInts nints2{.nums={10,10,0,20}, .valid={std::bitset<32>("00000000000000000000000000001111")}};

    //drop zero values from the denominator
    sparrow::DropZero(&nints2);

    //divid
    auto divisionResult = sparrow::Divide(&nints1, &nints2);

    if (divisionResult.ok) {
        //compute average of the resulting numbers; ignore invalids
        auto averageResult = sparrow::Average(&divisionResult.value);

        if (averageResult.ok) {
            std::cout << averageResult.value;
        } else {
            std::cout << "Average operation failed.";
        }
    } else {
        std::cout << "Division operation failed.";
    }

    return 0;
}
