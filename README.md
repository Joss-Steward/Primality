# Primality
A distributed finder of prime written in Haskell. Because Haskell is cool. Distributed-ness to come later.

## Build Instructions
Before you can build this application you will need a few things on your local machine. This program has _only_ been tested on Linux-based systems, and although there is no reason to believe it won't work on Windows or OS/X, we make no promises.

### General Requirements
1. GHC (The Glasgow Haskell Compiler)
   - Note that if you are using the Ubuntu repositories the version of GHC you install may be out of date.
2. Cabal *gasp*
3. The `monad-par` package (Installed from Cabal)

### Extremely detailed requirements
In case the above is daunting, and assuming you are on Ubuntu (or an Ubuntu-based distribution) you may do the following:
```
sudo apt-get install haskell-package
cabal install monad-par
```

### Actual build instructions
To build this program, run:
```
ghc main.hs primeTest.hs -rtsopts -threaded -O2
```

## Using this program
At the moment, this application accepts two arguments - a lower bound and an upper bound. A few additional flags must be added to encourage it to run multiple threads.

```
./main <lowerBound> <upperBound> +RTS -N<threads>
```

lowerBound is, of course, the lower bound of the range to search.
upperBound is, surprisingly, the upper bound of the range to search.
threads specifies the number of threads to divide the work between. Leaving it blank will automatically determine the number of threads your system supports (either the number of cores, or the number of cores * 2 if you have hyperthreading) and use that many threads.


## Timing program performance
We have here a very simple application that finds all the primes in a given range. Naturally the favorite use for such a program is comparing how long a given range takes on various CPUs. The example below finds the first 1 million prime numbers and dumps them into `/dev/null`, then it prints out how long that totally productive task took. Way to put that computer to good use, guys.

```
time ./main 1 15485864 +RTS -N > /dev/null
```

TODO:
- Create a local manager that will accept an upper and lower bound
- Create a Global manager that will divide out the work between the computers
- Get the global manager talking to the local managers over the network (sockets)
- Allow the global manager to ping all ip addresses in a given range to find free local managers
- Allow the local managers to report their values back to the global which will then log it to a file
