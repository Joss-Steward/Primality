import Control.Monad
import Control.Monad.Par
import Control.Concurrent
import Data.List
import Data.List.Split
import System.Environment
import System.IO
import Network

-- processChunk :: [Integer] -> [Integer]
-- processChunk a = filter isPrime a
-- 
-- findPrimes :: [Integer] -> Int -> [[Integer]]
-- findPrimes a n = runPar $ parMap processChunk $ splitEvery ((length a) `div` n) a

blockSize = 1000000

startServer = withSocketsDo $ do
    sock <- listenOn  $ PortNumber 32101
    
    sockHandler sock [1, blockSize .. ]
    

sockHandler :: Socket -> IO ()
sockHandler sock list = do
    (handle, _, _) <- accept sock
    hSetBuffering handle NoBuffering
    x <- hGetLine handle
    
    forkIO $ handleRequest handle $ fst list
    drop x list
    
    
    sockHandler sock

handleRequest handle r = do
    hPutStrLn handle lower upper
    where
        strRange = show r
        lower = r
        upper = show (r + blockSize)
    
    
    
main = do
    args <- getArgs
    n <-  getNumCapabilities
    startServer
        
        
        
