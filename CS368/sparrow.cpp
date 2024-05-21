#include <cstdlib>
#include <iostream>
#include <bitset>
#include <vector>
#include <utility>
#include <cmath>
#include <algorithm>
#include "sparrow.h"

using std::bitset;
namespace sparrow{
    namespace warmup{

        unsigned CountBits(std::bitset<32> bits, unsigned pos, unsigned len){
            unsigned count = 0;
            if(pos >= 32){
                return 0;
            }else if (pos + len > 32 || len > 32){
                len = 32 - pos; //check bounds of bitset 32
            } 
    
            for (unsigned i = pos; i < pos + len; i++) {
                if (bits[i]) { //if this bit is 1 or true increase count
                    count++;
                }
            }
            
            return count;
        }

        unsigned CountBits(std::vector<std::bitset<32>>& bitsets) {
            unsigned total_count = 0;
            for (auto& bits : bitsets) {
                for (int i = 0; i < 32; i++) {
                    if (bits[i]) {
                        total_count++;
                    }
                }
            }
            return total_count;
        }

        std::pair<std::vector<std::bitset<32>>, bool> BitAnd(std::vector<std::bitset<32>> a, std::vector<std::bitset<32>> b) {
            std::vector<std::bitset<32>> result;
            if (a.size() != b.size()) {
                return {std::vector<std::bitset<32>>(), false};//not same size
            }

            for (unsigned i = 0; i < a.size(); i++) {
                result.push_back(a[i] & b[i]); //bitwise & on the corresponding bitsets for each vector
            }

            return {result, true};
        }
    }

    void DropZero(NullableInts* nints) {
        if (nints == nullptr) return;

        for (size_t i = 0; i < nints->nums.size(); ++i) {
            //if the current number is 0
            if (nints->nums[i] == 0) {
                //calculate which bitset and which bit within that bitset corresponds to i
                size_t bitsetIndex = i / 32;
                size_t bitIndex = i % 32;

                //set the corresponding valid bit to false
                nints->valid[bitsetIndex][bitIndex] = false;
            }
        }
    }

    AverageResult Average(const NullableInts* nints) {
        if (nints == nullptr || nints->nums.empty()) {
            return {0.0f, false}; //return ok=false if input is null or empty
        }

        float sum = 0.0f;
        size_t validCount = 0;

        for (size_t i = 0; i < nints->nums.size(); ++i) {
            //check if the number at index i is valid
            if (i / 32 < nints->valid.size() && nints->valid[i / 32][i % 32]) {
                sum += nints->nums[i];
                ++validCount;
            }
        }

        if (validCount == 0) {
            return {0.0f, false}; //no valid numbers to compute an average
        }

        float average = sum / validCount;
        return {average, true}; //return the computed average and ok=true
    }

    AverageResult Average(const NullableInts& nints){
        if (nints.nums.empty()) {
            return {0.0f, false}; // empty input handling
        }

        float sum = 0.0f;
        size_t validCount = 0;
        for (size_t i = 0; i < nints.nums.size(); ++i) {
            if (i / 32 < nints.valid.size() && nints.valid[i / 32][i % 32]) {
                sum += nints.nums[i];
                ++validCount;
            }
        }

        if (validCount == 0) {
            return {0.0f, false}; // no valid numbers to compute an average
        }

        float average = sum / validCount;
        return {average, true}; // return the computed average and ok=true
    }

    DivideResult Divide(const NullableInts* numerator, const NullableInts* denominator) {
        if (!numerator || !denominator) {
            return {{}, false}; //failure if either input is null
        }

        auto bitAndResult = warmup::BitAnd(numerator->valid, denominator->valid);
        if (!bitAndResult.second) {
            return {{}, false}; //if error in BitAnd
        }

        NullableInts result;
        result.valid.resize(bitAndResult.first.size(), std::bitset<32>(0)); //ensure that result.valid has enough entries to represent the validity of each division result + default to all 0 or false
        
        size_t minSize = std::min(numerator->nums.size(), denominator->nums.size()); //maximum number of divisions that can be performed as you cannot divide elements beyond the size of the shorter vector.
        result.nums.resize(minSize, 0); //result vector appropriate size; avoiding out-of-bounds access

        for (size_t i = 0; i < minSize; ++i) {
            if (bitAndResult.first[i / 32][i % 32]) { //[first member of pair within 32][check validity in BitAnd result]
                if (denominator->nums[i] != 0) { //ensure denominator is not zero
                    result.nums[i] = numerator->nums[i] / denominator->nums[i];
                    result.valid[i / 32].set(i % 32); //mark result as valid
                }
            }
        }

        return {result, true};
    }

    NullableInts* StrsToNullableInts(const std::vector<std::string>& inputs) {
        //new NullableInts instance on the heap
        NullableInts* result = new NullableInts;
        size_t size = inputs.size();
        //get bitsets to cover all inputs (each bitset covers 32 inputs)
        size_t numBitsets = static_cast<size_t>(ceil(size / 32.0));
        result->valid.resize(numBitsets, std::bitset<32>());
        for (size_t i = 0; i < size; ++i) {//input strings
            size_t bitsetIndex = i / 32;
            size_t bitIndex = i % 32;

            if (inputs[i] == "null") {
                result->valid[bitsetIndex][bitIndex] = false;
                result->nums.push_back(0); //placeholder value
            } else {
                //convert string to integer and set the corresponding bit to true
                int value = std::atoi(inputs[i].c_str());
                result->nums.push_back(value);
                result->valid[bitsetIndex].set(bitIndex);
            }
        }

        return result;
    }

    size_t NullableIntsToArray(const NullableInts& nints, int** array) {
        if (!array) {
            return 0; // Guard against nullptr for array parameter
        }

        std::vector<int> validNums;

        for (size_t i = 0; i < nints.nums.size(); ++i) {
            size_t bitsetIndex = i / 32;
            size_t bitIndex = i % 32;

            //if the bit for this index is set;the value is valid
            if (bitsetIndex < nints.valid.size() && nints.valid[bitsetIndex].test(bitIndex)) {
                validNums.push_back(nints.nums[i]);
            }
        }

        *array = new int[validNums.size()];

        //copy valid numbers into the allocated array
        for (size_t i = 0; i < validNums.size(); ++i) {
            (*array)[i] = validNums[i];
        }

        return validNums.size();
    }

    //default constructor initializes an IntColumn with no data
    IntColumn::IntColumn() : data(), valid() {}

    //constructs an IntColumn from a vector of string inputs
    IntColumn::IntColumn(const std::vector<std::string>& inputs) {
        for (const std::string& str : inputs) {
            if (str == "null") {
                data.push_back(0);  //use 0 as a placeholder for null values
                valid.push_back(false);
            } else {
                try {
                    int num = std::stoi(str);
                    data.push_back(num);
                    valid.push_back(true);
                } catch (const std::exception& e) {
                    //handle the unlikely case of non-convertible strings which are supposed to be valid numbers
                    std::cerr << "Invalid input detected: " << e.what() << ". This entry will be marked as invalid." << std::endl;
                    data.push_back(0);  //use 0 as a placeholder for invalid numeric values
                    valid.push_back(false);
                }
            }
        }
    }

    //private constructor to initialize from vectors directly
    IntColumn::IntColumn(const std::vector<int>& data, const std::vector<bool>& valid) : data(data), valid(valid) {}


    std::ostream& operator<<(std::ostream& os, const IntColumn& column) {
        os << "IntColumn:" << std::endl;
        for (size_t i = 0; i < column.data.size(); ++i) {
            if (column.valid[i]) {
                os << column.data[i] << std::endl;
            } else {
                os << "null" << std::endl;
            }
        }
        return os;
    }

    void IntColumn::DropZero() {
        for (size_t i = 0; i < data.size(); ++i) {
            if (data[i] == 0) {
                valid[i] = false;
            }
        }
    }

    AverageResult IntColumn::Average() {
        if (data.empty()) return {0.0f, false};

        double sum = 0.0;
        size_t count = 0;
        for (size_t i = 0; i < data.size(); ++i) {
            if (valid[i]) {
                sum += data[i];
                ++count;
            }
        }

        if (count == 0) return {0.0f, false};  //no valid entries to average

        return {static_cast<float>(sum / count), true};
    }

    IntColumn IntColumn::operator/(const IntColumn& other) {
        size_t minSize = std::min(data.size(), other.data.size());
        std::vector<int> newData(minSize);
        std::vector<bool> newValid(minSize, false);

        for (size_t i = 0; i < minSize; ++i) {
            if (valid[i] && other.valid[i] && other.data[i] != 0) {
                newData[i] = data[i] / other.data[i];
                newValid[i] = true;
            }
        }

        return IntColumn(newData, newValid);
    }

    //returns the size of the data vector
    int IntColumn::Size() const {
        return data.size();
    }

    //access elements with support for negative indexing
    const int* IntColumn::operator[](int idx) const {
        if (idx < 0) {
            idx = Size() + idx;  //convert negative index to positive
        }
        if (idx >= 0 && idx < Size() && valid[idx]) {
            return &data[idx];  //return address of the data element
        }
        return nullptr;  //return nullptr for invalid or missing values
    }

    NamedIntColumn::NamedIntColumn(const std::string& name, const std::vector<std::string>& inputs)
        : name(name), col(new IntColumn(inputs)) {
    }

    NamedIntColumn::NamedIntColumn(const NamedIntColumn& other)
        : name(other.name), col(new IntColumn(*(other.col))) {
    }

    NamedIntColumn::NamedIntColumn(NamedIntColumn&& other) noexcept
        : name(std::move(other.name)), col(other.col) {
        other.col = nullptr;
    }

    NamedIntColumn& NamedIntColumn::operator=(const NamedIntColumn& other) {
        if (this != &other) {
            name = other.name;
            delete col;
            col = new IntColumn(*(other.col));
        }
        return *this;
    }

    NamedIntColumn& NamedIntColumn::operator=(NamedIntColumn&& other) noexcept {
        if (this != &other) {
            name = std::move(other.name);
            delete col;
            col = other.col;
            other.col = nullptr;
        }
        return *this;
    }

    NamedIntColumn::~NamedIntColumn() {
        delete col;
    }

    Table::Table() {
    }

    //add a column by creating a shared pointer from a NamedIntColumn object
    void Table::AddCol(const NamedIntColumn& col) {
        auto sp = std::make_shared<NamedIntColumn>(col);
        columns.push_back(sp);
    }

    void Table::AddCol(std::shared_ptr<NamedIntColumn> col) {
        columns.push_back(col);
    }

    //retrieve a column by name
    std::shared_ptr<NamedIntColumn> Table::operator[](const std::string& colName) const {
        auto it = columnMap.find(colName);
        if (it != columnMap.end()) {
            return it->second;
        }
        return nullptr;
    }

    std::ostream& operator<<(std::ostream& os, const Table& table) {
        const auto& columns = table.getColumns();
        
        //check if there are any columns
        if (columns.empty()) {
            return os;
        }

        //frint column names
        for (size_t i = 0; i < columns.size(); ++i) {
            os << columns[i]->name;
            if (i < columns.size() - 1) os << ",";
        }
        os << std::endl;

        //find the maximum number of rows in any column
        size_t maxRows = 0;
        for (const auto& col : columns) {
            maxRows = std::max<size_t>(maxRows, col->col->Size());
        }

        // Print rows
        for (size_t row = 0; row < maxRows; ++row) {
            for (size_t col = 0; col < columns.size(); ++col) {
                if (row < columns[col]->col->Size()) {
                    const int* value = (*columns[col]->col)[row];
                    if (value) {
                        os << *value;
                    } else {
                        os << "null";
                    }
                } else {
                    os << "null";
                }
                if (col < columns.size() - 1) os << ",";
            }
            os << std::endl;
        }

        return os;
    }
}

/*
int main(){

    sparrow::NullableInts myNullableInts;
    std::cout << myNullableInts;

    sparrow::NullableInts myNullableInts;
    sparrow::DropZero(&myNullableInts);

    
    using sparrow::warmup::CountBits;

    std::cout << "test original function: " << "\n";
    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000001"), 0, 32) << "\n"; //return 3
    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000001"), 2, 30) << "\n"; //return 2
    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000001"), 2, 28) << "\n"; //return 0

    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000001"), 32, 1) << "\n"; //pos outside -> return 0
    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000001"), 200, 32) << "\n"; //pos outside -> return 0

    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000001"), 0, 320) << "\n"; //len outside -> return 3
    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000001"), 2, 300) << "\n"; //len outside -> return 2
    std::cout << CountBits(std::bitset<32>("11000000000000000000000000000011"), 1, 208) << "\n"; //len outside -> return 3


    //overloaded countbit
    std::cout << "test overload function: " << "\n";

    std::vector<std::bitset<32>> bitsets = {
        std::bitset<32>("11000000000000000000000000000001"),
        std::bitset<32>("00100000000000000000000000000011")
    };

    std::cout << CountBits(bitsets) << "\n"; //return 6


    //bitand function
    std::vector<std::bitset<32>> vector1 = {
        std::bitset<32>("11010000110101001110001011101010"),
        std::bitset<32>("0000111100001111000011110000")
    };
    
    std::vector<std::bitset<32>> vector2 = {
        std::bitset<32>("10101010101010101010101010101010"),
        std::bitset<32>("0101010101010101010101010101")
    };

    using sparrow::warmup::BitAnd;

    auto [resultAndVec, isValid] = BitAnd(vector1, vector2);

    if(isValid){
        std::cout << "Vectors a and b are valid. The BitAnd function returns:\n";
        for (auto& bitset : resultAndVec) {
            std::cout << bitset << '\n';
        }
        //10000000100000001010001010101010
        //00000000010100000101000001010000
    }else{
        std::cout << "Vectors a and b must have the same length in order to be valid\n";
    }
}
*/
