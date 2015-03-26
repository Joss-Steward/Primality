import System.IO
import Network

-- This is seperate from the server so we can kill the server but catch any remaining 
-- primes that need to be logged still

filename :: String
filename = "primes.log"

startServer = withSocketsDo $ do
   sock <- listenOn  $ PortNumber 32100

   sockHandler sock

-- This is not threaded because we can only have 1 thread with write access anyway
-- If this ends up bottlenecking it we will need to implement a queue of some sort
sockHandler :: Socket -> IO ()
sockHandler sock = do
   (handle, hostname, port) <- accept sock
   
   putStrLn ("Connected to: " ++ hostname ++ " at " ++ show port)
   
   hSetBuffering handle NoBuffering
   x <- hGetContents handle

   appendFile filename x
   
   sockHandler sock

main = startServer
      
      
      
