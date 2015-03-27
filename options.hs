import System.Console.GetOpt
import System.Environment
import System.Exit
import System.IO
import Control.Monad
import Data.List
import Data.Char

-- This file handles parsing and interpreting
-- the command line options.

-- Options is a data structure which holds the
-- parsed information.
data Options = Options  { optSlave :: Bool
                        , optMasterIP :: String
                        , optMasterPort :: Int
                        , optLowerLimit :: Integer
                        , optUpperLimit :: Integer
                        }

-- Default Options
startOptions :: Options
startOptions = Options  { optSlave = False
                        , optMasterIP = "127.0.0.1"
                        , optMasterPort = 32101
                        , optLowerLimit = 0
                        , optUpperLimit = 10
                        }

-- Option parsing specification
options :: [OptDescr (Options -> IO Options )]
options =
   [ Option "s" ["server"]
      (ReqArg
         (\arg opt -> return opt { optMasterIP = arg, optSlave = True })
         "[SERVER IP]")
      "Default: 127.0.0.1"
   , Option "p" ["port"]
      (ReqArg
         (\arg opt -> return opt { optMasterPort = read arg, optSlave = True })
         "[SERVER PORT]")
      "Default: 32101"
   , Option "l" ["lower"]
      (ReqArg
         (\arg opt -> return opt { optLowerLimit = read arg })
         "[LOWER LIMIT]")
      "Default: 0"
   , Option "u" ["upper"]
      (ReqArg
         (\arg opt -> return opt { optUpperLimit = read arg })
         "[UPPER LIMIT]")
      "Default: 10"
   , Option "p" ["slave"]
      (NoArg
         (\opt -> return opt { optSlave = True }))
      "Run as slave with default settings"
   , Option "h" ["help"]
      (NoArg
         (\_ -> do
            prg <- getProgName
            hPutStrLn stderr (usageInfo prg options)
            exitWith ExitSuccess))
      "Show help"
   ]

writeError msg = hPutStrLn stderr msg

runAsSlave serverIP serverPort = do
   writeError $ "Running as slave"
   writeError $ "Connecting to server @ " ++ serverIP ++ ":" ++ show serverPort

runLocal lower upper = do
   writeError $ "Running locally"
   writeError $ "Lower Limit: " ++ show lower
   writeError $ "Upper Limit: " ++ show upper

main = do
   args <- getArgs
   let (actions, nonOptions, errors) = getOpt RequireOrder options args
   opts <- foldl (>>=) (return startOptions) actions

   -- Bind the options to local names
   let Options { optSlave = slave
               , optMasterIP = serverIP
               , optMasterPort = serverPort
               , optLowerLimit = lower
               , optUpperLimit = upper } = opts

   when slave $ runAsSlave serverIP serverPort
   when (not slave) $ runLocal lower upper










