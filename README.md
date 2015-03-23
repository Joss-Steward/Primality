# Primality
A distributed finder of prime written in Haskell. Because Haskell is cool. Distributed-ness to come later.

Right now it is hard-coded for a max of two threads. This will be changed at a later date.

Before Building:
You will need to have the monad-par package installed.
Run: "cabal install monad-par"

To Build:
"ghc main.hs primeTest.hs -rtsopts -threaded -O2"

To Run:
"./main +RTS -N2"
This will run the program with 2 threads.

TODO:
- Create a local manager that will accept an upper and lower bound
- Create a Global manager that will divide out the work between the computers
- Get the global manager talking to the local managers over the network (sockets)
- Allow the global manager to ping all ip addresses in a given range to find free local managers
- Allow the local managers to report their values back to the global which will then log it to a file
