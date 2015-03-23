import Primes
import Control.Monad.Par

calculatePrimes :: Integer -> Integer -> Integer -> [Integer]
calculatePrimes lower middle upper = runPar $ do
   calcLowerHalf <- (spawn . return) (listPrimes lower middle)
   calcUpperHalf <- (spawn . return) (listPrimes middle upper)
   lowerHalf <- get calcLowerHalf
   upperHalf <- get calcUpperHalf
   return $ lowerHalf ++ upperHalf

main = do
   print $ calculatePrimes 1 500000 1000000
