CXX = g++-13
CXXFLAGS = -Wall -fPIC -std=c++17
LDFLAGS = -L. -lsparrow

all: libsparrow.so p1 p2 p3

#g++-13 -Werror -fPIC -std=c++17 -o sparrow sparrow.cpp
#compile the sparrow.cpp into a shared library libsparrow.so
libsparrow.so:
	$(CXX) $(CXXFLAGS) -shared sparrow.cpp -o libsparrow.so

#compile p1.cpp into an executable p1, linking with libsparrow.so
p1: p1.cpp libsparrow.so
	$(CXX) $(CXXFLAGS) p1.cpp -o p1 $(LDFLAGS)

#compile p2.cpp into an executable p2, linking with libsparrow.so
p2: p2.cpp libsparrow.so
	$(CXX) $(CXXFLAGS) p2.cpp -o p2 $(LDFLAGS)

#compile p3.cpp into an executable p3, linking with libsparrow.so
p3: p3.cpp libsparrow.so
	$(CXX) $(CXXFLAGS) p3.cpp -o p3 $(LDFLAGS)

#compile p4.cpp into an executable p4, linking with libsparrow.so
p4: p4.cpp libsparrow.so
	$(CXX) $(CXXFLAGS) p4.cpp -o p4 $(LDFLAGS)

#clean compiled files
clean:
	rm -f libsparrow.so p1 sparrow p2 p3 p4 test2_bitcounter test3_overload test4_bit_and test6_struct test7_dropzero test8_average test9_divide test11_ref test12_const test13_parse test14_dblptr test16_constructor test17_cout test18_methods test19_indexing test21_destructor test22_cp_constructor test23_cp_assignment test24_mv_constructor test25_mv_assignment test26_add_col test27_get_col test28_output test29_files
