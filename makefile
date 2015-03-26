all:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2
	ghc server.hs -rtsopts -threaded -O2
	ghc logger.hs -O2
	

debug:
	ghc main.hs primeTest.hs -rtsopts -threaded -O2 -eventlog

cabalInstall:
	cabal update
	cabal install network
	cabal install monad-par
	cabal install split

runServer:
	./server

runClient:
	./main +RTS -N

runLogger:
	./logger

runAll:
	make runServer &
	make runLogger &
	make runClient
	pkill server
	pkill logger

clean:
	rm *.o *.hi main server logger
