#include <iostream>
#include <vector>
#include <string>
#include "sparrow.h"

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cout << "failed" << std::endl;
        return 0;
    }

    std::vector<std::string> inputs;
    for (int i = 1; i < argc; i++) {
        inputs.push_back(argv[i]);
    }

    sparrow::NullableInts* nints = sparrow::StrsToNullableInts(inputs);
    if (nints == nullptr) {
        std::cout << "failed" << std::endl;
        return 0;
    }

    sparrow::AverageResult result = sparrow::Average(*nints);

    delete nints; 

    if (result.ok) {
        std::cout << result.value << std::endl;
    } else {
        std::cout << "failed" << std::endl;
    }

    return 0;
}
