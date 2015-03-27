module Main (main) where

import Primes
import Control.DeepSeq
import Control.Monad
import Control.Monad.Par
import Control.Concurrent
import Data.List
import Data.List.Split
import System.Environment
import System.IO
import System.Exit
import Data.Char
import Network
import GetOptions (Options(..), startOptions, options, parseOpts)

writeError msg = hPutStrLn stderr msg

writePrimeStats :: [[Integer]] -> IO ()
writePrimeStats primes = do
   forM_ (zip [1..] primes) (\(t,p) -> do
      writeError $ "Thread " ++ (show t) ++ " found " ++ show (length p) ++ " primes")
   writeError $ "Total primes found: " ++ show (foldl (+) 0 $ map length primes)

runAsSlave :: String -> PortNumber -> IO()
runAsSlave serverIP serverPort = do
   numThreads <- getNumCapabilities
   writeError $ "Running as slave"
   writeError $ "Connecting to server @ " ++ serverIP ++ ":" ++ show serverPort
   handle <- connectTo serverIP $ PortNumber serverPort
   writeError $ "Connected to server"
   hPutStrLn handle (show numThreads)
   inp <- hGetLine handle
   let   components = splitOn " " inp
         lower = read (components !! 0) :: Integer
         upper = read (components !! 1) :: Integer
         primes = findPrimes [lower..upper] numThreads
   logger <- connectTo serverIP $ PortNumber 4242
   mapM_ (hPutStrLn logger . show) primes

runLocal lower upper = do
   numThreads <- getNumCapabilities
   writeError $ "Running locally"
   writeError $ "Using " ++ show numThreads ++ " threads"
   writeError $ "Lower Limit: " ++ show lower
   writeError $ "Upper Limit: " ++ show upper
   let primes = findPrimes [lower..upper] numThreads
   writePrimeStats primes
   mapM_ (putStrLn . show) primes -- print the primes to the console

main = do
   args <- getArgs
   --let (actions, nonOptions, errors) = getOpt RequireOrder options args
   --opts <- foldl (>>=) (return startOptions) actions

   opts <- parseOpts args
   -- Bind the options to local names
   let Options { optSlave = slave
               , optMasterIP = serverIP
               , optMasterPort = serverPort
               , optLowerLimit = lower
               , optUpperLimit = upper } = opts

   when slave $ runAsSlave serverIP $ fromIntegral serverPort
   when (not slave) $ runLocal lower upper
