all:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2

debug:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2 -eventlog

clean:
	rm *.o *.hi main
