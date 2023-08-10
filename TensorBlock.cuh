#include <iostream>
#include <vector>
#include <string>
#include <exception>


int FuncCompare(const void* Arg1,const void* Arg2){
    std::cout << *(const uint32_t*)Arg1 << " $$$$$$ " << *(const uint32_t*)Arg2 << std::endl;
    uint32_t Cmp1 { *(const uint32_t*)Arg1};
    uint32_t Cmp2 { *(const uint32_t*)Arg2};
    return (Cmp1 == Cmp2)?0:({
        (Cmp1 > Cmp2)?1:-1;
    });
}


int FuncCmpFlt(const void* Arg1,const void* Arg2){
    std::cout << *(const float*)Arg1 << " $$$$$$ " << *(const float*)Arg2 << std::endl;
    float Cmp1 { *(const float*)Arg1};
    float Cmp2 { *(const float*)Arg2};
    return (Cmp1 == Cmp2)?0:({
        (Cmp1 > Cmp2)?1:-1;
    });
}
