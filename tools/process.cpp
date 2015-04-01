#include <iostream>
#include <fstream>
#include <algorithm>
#include <string>
#include <set>
#include <sstream>
#include <iterator>
#include <vector>

//using namespace std;

long int max = 0;
long int min = 2147483647;

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
std::vector<int>* readFileIntoSet() {
    std::vector<int>* primes = new std::vector<int>;
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
                long int tmp = std::stoi(nums[i]);
                primes->push_back(tmp);
                
                if(tmp > max) 
                    max = tmp;
                if(tmp < min)
                    min = tmp;
                
            }
        }
    }
    
    return primes;
    
}

int main() {
    
    std::vector<int>* primes = readFileIntoSet();
//     for(std::set<int>::iterator it = primes.begin(); it != primes.end(); ++it)
//     {
//         std::cout << *it << std::endl;
//     }
    std::cout << primes->size() << std::endl;
    //std::sort(primes->begin(), primes->end());
    std::cout << "Lowest Prime: " << min << std::endl;
    std::cout << "Highest Prime: " << max << std::endl;
    delete primes;
    
    return 0;
}

