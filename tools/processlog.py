import re

raw = ""
stringList = []
intList = set()
sortedList = []

def process():
    global raw, stringList, intList, sortedList

    with open("../bin/primes.log", "r") as f:
        raw = f.read()
        
    stringList = re.findall(r"\d+", raw)
    numBefore = len(stringList)
    print("Number of primes found in raw log file: " + str(len(stringList)))
    
    for x in range(0, len(stringList)):
        intList.add(int(stringList[x]))
    numAfter = len(intList)
    print("Number of distinct primes found: " + str(len(intList)))
    
    if numAfter != numBefore:
        print("~~DUPLICATION FOUND!!~~")
    else:
        print("~No duplicates found~")
    
    sortedList = sorted(intList)
    
    print("Lowest prime found: " + str(sortedList[0]))
    print("Highest prime found: " + str(sortedList[-1]))

if __name__ == "__main__":
    process()
    csv = ""
    
    for x in range(0, len(sortedList)):
        csv += str(sortedList[x])
        if x < len(sortedList)-1:
            csv += ","
    
    with open("primes.log.processed", "w") as f:
        f.write(csv)
 
