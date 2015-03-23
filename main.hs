import Primes
import Control.Monad
import Control.Monad.Par
import Control.Concurrent
import Data.List
import Data.List.Split
import System.Environment

processChunk :: [Integer] -> [Integer]
processChunk a = filter isPrime a

findPrimes :: [Integer] -> Int -> [[Integer]]
findPrimes a n = runPar $ parMap processChunk $ splitEvery ((length a) `div` n) a

main = do
   args <- getArgs
   n <-  getNumCapabilities
   case args of
      [lowerStr, upperStr] -> do
         putStrLn $ "Calculating Primes from " ++ lowerStr ++ " to " ++ upperStr
         putStrLn $ "Using " ++ show n ++ " threads"
         putStrLn $ show $ findPrimes [lower..upper] n
         where
            lower = read lowerStr :: Integer
            upper = read upperStr :: Integer
         -- print $ "lower: " ++ lower ++ " upper: " ++ upper
      _ ->
         print "Not gonna work"
         -- print $ findPrimes [1..1000000] n



