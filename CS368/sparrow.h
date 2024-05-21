#include <bitset>
#include <vector>
#include <utility>
#include <unordered_map>
#include <memory>
#include <string>

namespace sparrow {
    namespace warmup {

        unsigned CountBits(std::bitset<32> bits, unsigned pos, unsigned len);

        unsigned CountBits(std::vector<std::bitset<32>>& bitsets);

        std::pair<std::vector<std::bitset<32>>, bool> BitAnd(std::vector<std::bitset<32>> a, std::vector<std::bitset<32>> b);
    }

    struct NullableInts {
        std::vector<int> nums; //vector of integers
        std::vector<std::bitset<32>> valid; //validity flags for integers
    };

    void DropZero(NullableInts* nints);

    struct AverageResult {
        float value; //computed average
        bool ok;//if the average calculation was successful
    };

    AverageResult Average(const NullableInts* nints);
    AverageResult Average(const NullableInts& nints);

    struct DivideResult {
        NullableInts value;//result of division
        bool ok; //if the operation was successful
    };

    DivideResult Divide(const NullableInts* a, const NullableInts* b);

    NullableInts* StrsToNullableInts(const std::vector<std::string>& inputs);

    size_t NullableIntsToArray(const NullableInts& nints, int** array);

    class IntColumn {
        private:
            std::vector<int> data;
            std::vector<bool> valid;
            IntColumn(const std::vector<int>& data, const std::vector<bool>& valid); 
        public:
            IntColumn();
            explicit IntColumn(const std::vector<std::string>& inputs);
            friend std::ostream& operator<<(std::ostream& os, const IntColumn& column);
            void DropZero();
            AverageResult Average();
            IntColumn operator/(const IntColumn& other);
            int Size() const;
            const int* operator[](int idx) const;
    };

    class NamedIntColumn {
        public:
            std::string name;
            IntColumn* col;

            NamedIntColumn(const std::string& name, const std::vector<std::string>& inputs);
            NamedIntColumn(const NamedIntColumn& other);
            NamedIntColumn(NamedIntColumn&& other) noexcept;
            NamedIntColumn& operator=(const NamedIntColumn& other);
            NamedIntColumn& operator=(NamedIntColumn&& other) noexcept;
            ~NamedIntColumn();
    };

    class Table {
    private:
        std::vector<std::shared_ptr<NamedIntColumn>> columns;
        std::unordered_map<std::string, std::shared_ptr<NamedIntColumn>> columnMap;

    public:
        Table();
        void AddCol(const NamedIntColumn& col);
        void AddCol(std::shared_ptr<NamedIntColumn> col);
        std::shared_ptr<NamedIntColumn> operator[](const std::string& colName) const;
        const std::vector<std::shared_ptr<NamedIntColumn>>& getColumns() const {
            return columns;
        }
    };
}
