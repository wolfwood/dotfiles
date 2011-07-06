import Yi hiding (Block, (.))

config ::Config
config = defaultEmacsConfig

main :: IO ()
main = yi $ config
