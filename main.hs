import Primes
import Control.Monad.Par
import Control.Monad
import Data.List.Split

processChunk :: [Integer] -> [Integer]
processChunk a = filter isPrime a

findPrimes :: [Integer] -> [[Integer]]
findPrimes a = runPar $ parMap processChunk $ splitEvery 500000 a

main = print $ findPrimes [1..1000000]
   -- print $ calculatePrimes 1 500000 1000000
