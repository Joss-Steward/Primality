all:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2

clean:
	rm *.o *.hi main
