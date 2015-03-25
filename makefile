all:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2
	ghc serverTest.hs -rtsopts -threaded -O2


debug:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2 -eventlog

cabalInstall:
	cabal update
	#cabal install network
	cabal install monad-par
	cabal install split

runServer:
	./serverTest

runClient:
	./main +RTS -N

runAll:
	make runServer &
	make runClient
	pkill serverTest

clean:
	rm *.o *.hi main
