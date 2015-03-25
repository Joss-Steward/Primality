import Primes
import Control.Monad
import Control.Monad.Par
import Control.Concurrent
import Data.List
import Data.List.Split
import System.Environment
import System.Console.GetOpt
import System.IO
import System.Exit
import Data.Char

-- Prime Mining --
processChunk :: [Integer] -> [Integer]
processChunk a = filter isPrime a

findPrimes :: [Integer] -> Int -> [[Integer]]
findPrimes a n = runPar $ parMap processChunk $ splitEvery ((length a) `div` n) a

-- Command line option handling --
data Options = Options { optControllerIP :: String }

-- Default Options --
startOptions :: Options
startOptions = Options { optControllerIP = "127.0.0.1" }

-- This also handles parsing the options --
-- In the future this function should be moved to another file --
options :: [ OptDescr (Options -> IO Options) ]
options =
   [ Option "s" ["server"]
      (ReqArg
         (\arg opt -> return opt { optControllerIP = arg })
         "SERVER IP")
      "IP of the Control Server"
   , Option "h" ["help"]
      (NoArg
         (\_ -> do
            prg <- getProgName
            hPutStrLn stderr (usageInfo prg options)
            exitWith ExitSuccess))
      "Show help"
   ]

main = do
   n <- getNumCapabilities
   args <- getArgs

   -- This actually parses the options --
   let (actions, nonOptions, errors) = getOpt RequireOrder options args
   opts <- foldl (>>=) (return startOptions) actions

   -- Bind the options to local names --
   let Options { optControllerIP = serverIp } = opts

   -- Demo a simple option --
   putStrLn $ "Server IP: " ++ serverIp

   case args of
      (lowerStr : upperStr : _) -> do
         putStrLn $ "Calculating Primes from " ++ lowerStr ++ " to " ++ upperStr
         putStrLn $ "Using " ++ show n ++ " threads"
         mapM_ (putStrLn . show) (findPrimes [lower..upper] n)
         where
            lower = read lowerStr :: Integer
            upper = read upperStr :: Integer
      _ ->
         print "Not gonna work"











