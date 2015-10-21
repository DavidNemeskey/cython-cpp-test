#ifndef TESTCLASS_HPP
#define TESTCLASS_HPP

#include <iostream>

class TestClass {
    public:
    
        int x, y;
    
        TestClass() { std::cout << "Calling constructor" << std::endl; }
        
        virtual ~TestClass() { std::cout << "Calling destructor" << std::endl; }
        
        inline int Multiply(int a, int b){
            return a*b;
        }
};

#endif

