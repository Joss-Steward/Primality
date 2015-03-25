all:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2

debug:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2 -eventlog

cabalInstall:
	cabal update
	#cabal install network
	cabal install monad-par
	cabal install split

clean:
	rm *.o *.hi main
