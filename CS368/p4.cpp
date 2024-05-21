#include "sparrow.h"
#include <iostream>
#include <vector>
#include <string>

int main(int argc, char* argv[]) {
    //start at index 1 to skip the program name
    std::vector<std::string> inputs(argv + 1, argv + argc);

    //create an IntColumn from command line arguments
    sparrow::IntColumn col(inputs);

    //drop zero values from the column
    col.DropZero();

    //print IntColumn
    std::cout << col;

    //calculate average and print result
    sparrow::AverageResult avg = col.Average();
    if (avg.ok) {
        std::cout << "Avg: " << avg.value << std::endl;
    } else {
        std::cout << "Avg: failed" << std::endl;
    }

    return 0;
}
