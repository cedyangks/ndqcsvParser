#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <string>
#include <functional>
#include <initializer_list>
#include <algorithm>
#include "TensorBlock.cuh"
#include <jsoncpp/json/json.h>
#include <omp.h>
#include <filesystem>

inline void StoreVector(std::basic_fstream<char>&& FileObjs){
    uint32_t lvalue = 10;
    std::cout << &lvalue << " Stack Memory Addr " << std::endl;
    std::vector<float3> VectorStorage[4];
    Json::Reader _ReadJson;
    Json::Value _ValueReader;
    _ReadJson.parse(FileObjs,_ValueReader);
    std::cout << _ValueReader.operator[]("result").operator[]("records").size() << " Size of Array element in vector " << std::endl;
    
    omp_set_num_threads(4);
    std::vector<std::array<float3,4>> StorageVector;
    StorageVector.reserve(1000);
    uint16_t VectorSize[4][16];
    VectorSize[0][0] = 1;
    VectorSize[1][0] = 201;
    VectorSize[2][0] = 401;
    VectorSize[3][0] = 601;
    uint16_t WorkCycle = 0;
    std::cout << _ValueReader.operator[]("result").operator[]("records").operator[](VectorSize[3][0]).operator[]("comp_sora_1m").asFloat() << " Floating point result " << std::endl;

    #pragma omp parallel
    {
        int ThreadIds = omp_get_thread_num();
        for (;WorkCycle < 200;WorkCycle++){
            StorageVector.operator[](VectorSize[ThreadIds][0]).operator[](0).x = _ValueReader.operator[]("result").operator[]("records").operator[](VectorSize[ThreadIds][0]).operator[]("comp_sora_1m").asFloat();
            StorageVector.operator[](VectorSize[ThreadIds][0]).operator[](0).y = _ValueReader.operator[]("result").operator[]("records").operator[](VectorSize[ThreadIds][0]).operator[]("comp_sora_3m").asFloat();
            StorageVector.operator[](VectorSize[ThreadIds][0]).operator[](0).z = _ValueReader.operator[]("result").operator[]("records").operator[](VectorSize[ThreadIds][0]).operator[]("comp_sora_6m").asFloat();
            VectorSize[ThreadIds][0] = VectorSize[ThreadIds][0] + 1;
        }
    }
    return;
}

inline void StrConvertFlt(const char* strliteral){
    float retval        {0.0};
    int Beforevalue = -1;
    const int len = (int)strlen(strliteral);
    int i = 0;
    int j = 0;
    while ((int)*(strliteral+i)  != 46){
        Beforevalue++;
        i++;
        continue;
    }
    i = 0;
    for (;j < len;){
        switch (i = (int)*strliteral++){
            case 48 ... 57:{
                retval = retval + ((float)(i - 0b00110000) * (pow(10.0f,(float)Beforevalue)));  //  expensive ops
                Beforevalue--;
                break;
            }
            case 46:{
                Beforevalue = -1; // turn-on switch
                break;
            }
            default:{break;}
        }
        j++;
        continue;
    }
    //std::cout << "Conversion Results " << retval << " || " << retval * 2.52f << std::endl;
    return;
}

// Overload function
inline void StrConvertFlt(const std::tuple<std::string,std::string>& strLiteral, std::tuple<std::array<float,16>,std::array<uint32_t,2>,uint32_t>& StorageArr){
    float retval        {0.0};
    int Beforevalue = -1;
    const int len = (int)(std::get<0>(strLiteral).length());
    int n_stackvar = -0;
    int i = 0;
    int j = 0;
    while ((int)(std::get<0>(strLiteral).operator[](i))  != 46){
        Beforevalue++;
        i++; // Expression statement; ending with semi-colon
        continue;
    }
    i = 0;
    for (;j < len;){
        switch (i = ((int)(std::get<0>(strLiteral).operator[](n_stackvar++)))){
            case 48 ... 57:{
                retval = retval + ((float)(i - 0b00110000) * (pow(10.0f,(float)Beforevalue)));  // most expensive operations
                Beforevalue--;
                break;
            }
            case 46:{
                Beforevalue = -1; // turn-on switch
                break;
            }
            default:{break;}
        }
        j++;
        std::get<0>(StorageArr).operator[](0) = retval;
        continue;
    }
    //std::cout << "Conversion Results " << retval << " Stored Results " << std::get<0>(StorageArr).operator[](0) << std::endl;
    return;
}


void CvrtStrToInt(const char* strLite){
    std::size_t xvalue = strlen(strLite);
    uint16_t Powvalue  {0};
    uint32_t AddStore {0};
    uint32_t Basevalue {0};
    uint16_t i {1};
    while (i < xvalue+1){
        switch ((int)strLite[xvalue-i]){
            case 44:{__asm__("nop");break;} 
            default:{
                AddStore = AddStore + ((uint32_t)strLite[xvalue-i] - 0b00110000) * (uint32_t)(pow(10.0f,(float)Basevalue));
                Basevalue = Basevalue + 1;
                break;
            }
        }
        i++;
        continue;
    }
    return;
}

template<typename T,std::size_t XGET>
void CvrtStrToInt(const char* strLite,std::tuple<std::array<float,16>,std::array<uint32_t,2>,uint32_t>& refArg){
    std::size_t xvalue = strlen(strLite);
    uint16_t Powvalue  {0};
    T AddStore {0};
    T Basevalue {0};
    uint16_t i {1};
    while (i < xvalue+1){
        switch ((int)strLite[xvalue-i]){
            case 44:{__asm__("nop");break;} 
            default:{
                AddStore = AddStore + ((uint32_t)strLite[xvalue-i] - 0b00110000) * (uint32_t)(pow(10.0f,(float)Basevalue)); // conversion to INT
                Basevalue = Basevalue + 1;
                break;
            }
        }
        i++;
        continue;
    }
    std::get<XGET>(refArg)[0] = AddStore;
    return;
}


uint32_t xvalues = 0;
template<std::size_t Z,std::size_t X>
void OperateData(std::tuple<std::string,std::string>& TupleArr,std::string& refArg,int16_t t,const std::vector<std::tuple<uint32_t,std::size_t,uint16_t,uint16_t>>& CommaPos){
    uint32_t y = 2;
    for (;(int)refArg.operator[](std::get<0>(CommaPos.operator[](xvalues+X))+y)!=34; y=y+1){
        std::get<X>(TupleArr).operator+=(refArg.operator[](std::get<0>(CommaPos.operator[](xvalues+X))+y)); // operator += to keep accumulating
    }
    xvalues = xvalues + Z;
    return;
}

std::tuple<std::string,std::string>* ParseCSV(std::string& refArg){
    std::string::iterator iterobjs = refArg.begin();
    std::vector<uint32_t> NewlinePos{};
    std::vector<std::tuple<uint32_t,std::size_t,uint16_t,uint16_t>> CommaPos{};
    std::vector<std::tuple<uint16_t,uint16_t>> DataPos{};
    uint16_t Newline {0};
    int32_t CommaCount {0};
    uint32_t WordCounter {0};
    uint32_t singleLinePos = 0;
    while (iterobjs.operator*() != '\0'){
        switch ((int)refArg.operator[](WordCounter)){
            case 10:{NewlinePos.push_back(WordCounter);singleLinePos=0;CommaCount=0;Newline++;break;}
            case 44:{CommaCount++;CommaPos.push_back({WordCounter,singleLinePos,Newline,CommaCount});DataPos.push_back({Newline,CommaCount});singleLinePos++;break;}
            default:{singleLinePos++;break;}
        }
        WordCounter++;
        iterobjs++;
        continue;
    }
    uint32_t InnerLoop = 0;
   //std::tuple<std::string,std::string> TupleArr[Newline+1]{};
   std::tuple<std::string,std::string>* TupleArr{ (std::tuple<std::string,std::string>* )std::malloc(10*9700)}; // an array of empty tuples 
    for (uint16_t t = 0;t <= Newline;){
        uint32_t Tracker = 1;
        if (std::get<0>(DataPos.operator[](InnerLoop+1)) == std::get<0>(DataPos.operator[](InnerLoop))){
            for (;std::get<0>(DataPos.operator[](InnerLoop+1)) == std::get<0>(DataPos.operator[](InnerLoop));){
                Tracker++;  // Tracker find the difference between current comma and the next one
                InnerLoop++;
                continue;
            }
            switch (Tracker){
                case 2:{if (t==0){xvalues = xvalues + Tracker;break;}OperateData<2,0>(TupleArr[t],refArg,t,CommaPos);break;}
                case 4:{if (t==0){xvalues = xvalues + Tracker;break;}OperateData<4,0>(TupleArr[t],refArg,t,CommaPos);break;}
                case 5:{if (t==0){xvalues = xvalues + Tracker;break;}OperateData<5,0>(TupleArr[t],refArg,t,CommaPos);break;}
                default:{OperateData<3,0>(TupleArr[t],refArg,t,CommaPos);break;}
            }
        }
        t++;
        InnerLoop++;
        continue;
    }
    xvalues = 0;
    InnerLoop = 0;
    for (uint16_t t = 0;t <= Newline;){
        uint32_t Tracker = 1;
        if (std::get<0>(DataPos.operator[](InnerLoop+1)) == std::get<0>(DataPos.operator[](InnerLoop))){
            for (;std::get<0>(DataPos.operator[](InnerLoop+1)) == std::get<0>(DataPos.operator[](InnerLoop));){
                Tracker++;  // Tracker find the difference between current comma and the next comma
                InnerLoop++;
                continue;
            }
            switch (Tracker){
                case 2:{if (t==0){xvalues = xvalues + Tracker;break;}OperateData<2,1>(TupleArr[t],refArg,t,CommaPos);break;}
                case 4:{if (t==0){xvalues = xvalues + Tracker;break;}OperateData<4,1>(TupleArr[t],refArg,t,CommaPos);break;}
                case 5:{if (t==0){xvalues = xvalues + Tracker;break;}OperateData<5,1>(TupleArr[t],refArg,t,CommaPos);break;}
                default:{OperateData<3,1>(TupleArr[t],refArg,t,CommaPos);break;}
            }
        }
        t++;
        InnerLoop++;
        continue;
    }

    return TupleArr;
}

int main(int args,const char** argvec){
    CvrtStrToInt("18,192,500");
    std::basic_fstream<char> fileInfos{"/home/cyang279/TensorsCapital/QCOM-07082023_intraday.csv",std::ios::in};
    float y = 13.5435;
    std::cout << log(y) << " Log values of y " << std::endl;
    long FileBegin {fileInfos.tellg()};
    fileInfos.seekg(0,std::ios::end); // function call expression -- statement with semicolon
    long FileEnd {fileInfos.tellg()};
    fileInfos.seekg(0,std::ios::beg);
    const std::size_t FileSize = (std::size_t)(FileEnd - FileBegin);
    std::string BufString{};
    BufString.reserve(FileSize);
    fileInfos.read(&BufString.operator[](0),FileSize);
    std::tuple<std::string, std::string>* TupsData = ParseCSV(BufString);
    std::cout << " Reading call return value " << std::endl;
    // Converting string to float and uint32
    std::tuple<std::array<float,16>,std::array<uint32_t,2>,uint32_t> ConvertedData[392];
    std::cout << sizeof(ConvertedData) << " Size of this element " << std::endl;
    
    int DataPos[3][16];         //
    DataPos[0][0] = 1;
    DataPos[1][0] = 108;
    DataPos[2][0] = 215;

    std::cout << " ************************** " << std::endl;
    omp_set_num_threads(3);
    #pragma omp parallel
    {
        int Icount = 0;
        int ids = omp_get_thread_num();
        for (;Icount < 43;){
            StrConvertFlt(TupsData[DataPos[ids][0]],ConvertedData[DataPos[ids][0]]);
            DataPos[ids][0] = (DataPos[ids][0])+1;
            Icount = Icount + 1;
            continue;
        }
    }
    // reset the variables
    DataPos[0][0] = 1;
    DataPos[1][0] = 108;
    DataPos[2][0] = 215;
    #pragma omp parallel
    {
        int Icount = 0;
        int ids = omp_get_thread_num();
        for (;Icount < 43;){
            CvrtStrToInt<uint32_t,1>(std::get<1>(TupsData[DataPos[ids][0]]).c_str(),ConvertedData[DataPos[ids][0]]);
            DataPos[ids][0] = (DataPos[ids][0])+1;
            Icount = Icount + 1;
            continue;
        }
    }

    // tuple is unordered map
    float* BaseAddr {(float*)&std::get<0>(ConvertedData[1]).operator[](0)};
    
    std::cout << " Expression should return a boolean " << (*BaseAddr == *(BaseAddr + 19)) << std::endl;
    std::cout << *BaseAddr << " || " << *(BaseAddr+19) << " || " << *(BaseAddr+57) << std::endl;
    std::qsort((void*)BaseAddr,50,76,(int (*)(const void*,const void*))&FuncCmpFlt);
    std::cout << *BaseAddr << " || " << *(BaseAddr+19) << " || " << *(BaseAddr+57) << std::endl;


    uint32_t Dim2Arr[][3] {{58,7,32},
                            {75,58,95},
                            {16,23,45},
                            {68,758,96},
                            {69,79,96}
                            };

    std::cout << *(*(Dim2Arr)+1) << " Before sort " << std::endl;
    std::cout << *(*(Dim2Arr+3)+1) << " Before sort " << std::endl;

    //std::qsort((void*)Dim2Arr,12,4,(int (*)(const void*,const void*))&FuncCompare);



    std::cout << " ^^^^^ " << std::get<1>(ConvertedData[95])[0] << " ****** " << std::get<1>(ConvertedData[25])[0] << std::endl;
    StoreVector(std::basic_fstream<char>{"/home/cyang279/TensorsCapital/ExtendedSora.json"});
    std::vector<float3> CudaObjs {{0.34,15.33,17.39},{17.657,89.325,48.652},{27.548,72.315,68.755}};
    std::string Csvrawvalue {"15.34"};
    std::cout << strtof(Csvrawvalue.c_str(),nullptr) << " Result from conversion " << std::endl;
    std::vector<float3>::iterator IterObjs = CudaObjs.begin();
    operator<<(std::cout.operator<<(IterObjs->x), " Floating Point ").operator<<(std::endl);
    auto LambdaExpr = [](std::string& RefObjs)->int{
        std::cout << RefObjs << " Memory Addrs " << std::endl;
        (void)std::system(RefObjs.c_str());
        return (int)RefObjs.length();
    };
    std::string Cmdlines {"pwd"};
    LambdaExpr(Cmdlines);
    return EXIT_SUCCESS;
}