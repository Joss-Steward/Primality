#include <iostream>
#include <fstream>
#include <algorithm>
#include <string>
#include <set>
#include <sstream>
#include <iterator>
#include <vector>
#include <cstdlib>

//using namespace std;

long unsigned int max = 0;
long unsigned int min = 2147483647;
long long count = 0;
std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems) {
    std::stringstream ss(s);
    std::string item;
    while (std::getline(ss, item, delim)) {
        elems.push_back(item);
    }
    return elems;
}

std::vector<std::string> split(const std::string &s, char delim) {
    std::vector<std::string> elems;
    split(s, delim, elems);
    return elems;
}

//Only use if the number of primes can reasonably fit in the ram as a whole
void readFileIntoSet() {
    //std::vector<int>* primes = new std::vector<int>;
    std::ifstream inFile("../bin/primes.log");
    
    std::string line;
    while(std::getline(inFile, line))
    {
        if(line != "[]")
        {
            line = line.substr(1, line.size()-2);
            
            std::vector<std::string> nums = split(line, ',');
            
            for(unsigned int i = 0; i < nums.size(); i++)
            {
				char* end;
				//char tab2[1024];
				//strcpy(tab2, nums[i].c_str());
                long unsigned int tmp = std::strtoul(nums[i].c_str(), &end, 10);
                //primes->push_back(tmp);
                count++;
                if(tmp > max) 
                    max = tmp;
                if(tmp < min)
                    min = tmp;
                
            }
        }
    }
    
    //return primes;
}

int main() {
    
    //std::vector<int>* primes = readFileIntoSet();
	readFileIntoSet();
//     for(std::set<int>::iterator it = primes.begin(); it != primes.end(); ++it)
//     {
//         std::cout << *it << std::endl;
//     }
    std::cout << count << std::endl;
    //std::sort(primes->begin(), primes->end());
    std::cout << "Lowest Prime: " << min << std::endl;
    std::cout << "Highest Prime: " << max << std::endl;
    //delete primes;
    
    return 0;
}

