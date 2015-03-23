import Primes
import Control.Monad.Par
import Control.Monad
import Data.List.Split
import Control.Concurrent

processChunk :: [Integer] -> [Integer]
processChunk a = filter isPrime a

findPrimes :: [Integer] -> Int -> [[Integer]]
findPrimes a n = runPar $ parMap processChunk $ splitEvery ((length a) `div` n) a

main = do
   n <-  getNumCapabilities
   print $ findPrimes [1..1000000] n
   -- print $ calculatePrimes 1 500000 1000000
