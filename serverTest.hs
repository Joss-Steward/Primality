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

blockSize :: Int
blockSize = 1000000

startServer = withSocketsDo $ do
    sock <- listenOn  $ PortNumber 32101
    
    sockHandler sock list
    where
        list :: [Int]
        list = [1, blockSize .. ]
    

sockHandler :: Socket -> [Int] -> IO ()
sockHandler sock list = do
    (handle, _, _) <- accept sock
    hSetBuffering handle NoBuffering
    x <- hGetLine handle
    
    forkIO $ handleRequest handle (list !! 0) (list !! (read x))
    
    sockHandler sock $ drop (read x) list


handleRequest handle l u = do
    hPutStrLn handle (lower ++ " " ++ upper)
    where
        lower = show l
        upper = show u
    
    
    
main = do
    args <- getArgs
    n <-  getNumCapabilities
    startServer
        
        
        
