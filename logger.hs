import Network
import System.IO
import Control.Exception
import Control.Concurrent
import Control.Concurrent.Chan
import Control.Monad
import Control.Monad.Fix (fix)

type Msg = (Int, String)

filename = "primes.log"

main :: IO ()
main = do
   chan <- newChan
--   sock <- socket AF_INET Stream 0
--   setSocketOption sock ReuseAddr 1
--   bindSocket sock (SockAddrInet 4242 iNADDR_ANY)
--   listen sock 2
   sock <- listenOn $ PortNumber 4242 
   chan' <- dupChan chan
   reader <- forkIO $ fix $ \loop -> do
      (nr', line) <- readChan chan'
      putStrLn $ "Results returned from slave " ++ show nr'
      appendFile filename (line ++ "\n")
      loop
   mainLoop sock chan 0

mainLoop :: Socket -> Chan Msg -> Int -> IO ()
mainLoop sock chan nr = do
   (handle, _, _) <- accept sock
   hSetBuffering handle NoBuffering

   forkIO  $ runConn handle chan nr
   mainLoop sock chan $! nr+1

runConn :: Handle -> Chan Msg -> Int -> IO ()
runConn hdl chan nr = do
   let broadcast msg = writeChan chan (nr, msg)
   handle (\(SomeException _) -> return ()) $ fix $ \loop -> do
      line <- hGetLine hdl
      broadcast line
      loop
   hClose hdl
