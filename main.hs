import Primes
import Control.DeepSeq
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
import Network

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

-- This should be turned into an option at some point
serverPort = 32101


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

startPrimeFinder inp n serverIp = do
   putStrLn $ "Calculating Primes from " ++ lowerStr ++ " to " ++ upperStr
   putStrLn $ "Using " ++ show n ++ " threads"
   mapM_ (putStrLn . show) primes
   forM_ (zip [1..n] primes) (\(t,p) -> do
         putStr $ "Thread " ++ show t
         putStrLn $ " found " ++ show (length p) ++ " primes")
   putStrLn $ "Total: " ++ show (foldl (+) 0 $ map length primes)
--    
--   show ("Total: " ++ show (foldl (+) 0 $ map length primes))
  
   logger primes serverIp
  
   where
         components = splitOn " " inp
         lowerStr = components !! 0
         upperStr = components !! 1
         lower = read (components !! 0) :: Integer
         upper = read (components !! 1) :: Integer
         primes = findPrimes [lower..upper] n

-- The serverPort-1 os simply to make sure the two servers are not on the same port
-- We can change this later if we need to
logger primes serverIp = do
   logger <- connectTo serverIp $ PortNumber (serverPort-1)
   -- hPutStrLn logger $ show (mapM_ (show) p)
   mapM_ (hPutStrLn logger . show) primes

   
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

   handle <- connectTo serverIp $ PortNumber serverPort
   hPutStrLn handle (show n)
   
   inp <- hGetLine handle
   
   startPrimeFinder inp n serverIp
