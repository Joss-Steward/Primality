import Control.Concurrent
import System.IO
import Network

blockSize :: Int
blockSize = 500000

startServer = withSocketsDo $ do
    sock <- listenOn  $ PortNumber 32101
    
    sockHandler sock list
    where
        list :: [Int]
        list = [1, blockSize .. ]
    
sockHandler :: Socket -> [Int] -> IO ()
sockHandler sock list = do
    (handle, hostname, port) <- accept sock
    hSetBuffering handle NoBuffering
    x <- hGetLine handle
    
    putStr ("Connected to: " ++ hostname ++ " at " ++ show port)
    forkIO $ handleRequest handle (list !! 0) (list !! (read x))
    putStrLn (", Given " ++ show (list !! 0) ++ " to " ++ show (list !! (read x)))
    
    sockHandler sock $ drop (read x) list

handleRequest handle l u = do
    hPutStrLn handle (lower ++ " " ++ upper)
    where
        lower = show l
        upper = show u
    
main = startServer
        
        
        
