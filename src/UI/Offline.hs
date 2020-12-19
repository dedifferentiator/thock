module UI.Offline where

import           Brick
import qualified Brick.Main             as M
import qualified Brick.Widgets.Edit     as E
import qualified Brick.Widgets.List     as L
import           Client
import           Control.Monad.IO.Class
import           Data.Time
import qualified Graphics.Vty           as V
import           Lens.Micro
import           Thock
import           UI.Attributes
import           UI.Common

draw :: GameState -> [Widget ()]
draw s = case s of
  MainMenu l -> drawMain l
  Practice g -> drawPractice g

drawMain :: MenuList -> [Widget ()]
drawMain l = [addBorder "" (titleWidget <=> listWidget)]
  where
    listWidget = vLimitPercent 20 $ L.renderList listDrawElement True l

handleKey :: GameState -> BrickEvent () e -> EventM () (Next GameState)
handleKey gs ev = case gs of
  MainMenu l -> handleKeyMainMenu l ev
  Practice g -> handleKeyPractice g ev

handleKeyMainMenu :: MenuList -> BrickEvent () e -> EventM () (Next GameState)
handleKeyMainMenu l (VtyEvent e) = case e of
  V.EvKey V.KEsc [] -> M.halt (MainMenu l)
  V.EvKey V.KEnter [] -> case L.listSelected l of
    Just i | i == 1 -> M.suspendAndResume (runOnline >> return (MainMenu l))
    _               -> startGameM Nothing (MainMenu l)
  ev -> L.handleListEvent ev l >>= M.continue . MainMenu
handleKeyMainMenu l _ = M.continue (MainMenu l)

handleKeyPractice :: Game -> BrickEvent () e -> EventM () (Next GameState)
handleKeyPractice g (VtyEvent ev) =
  case ev of
    V.EvKey V.KEsc [] -> M.halt (Practice g)
    V.EvKey (V.KChar 'b') [V.MCtrl] -> M.continue initialState
    V.EvKey (V.KChar 'r') [V.MCtrl] -> startGameM (Just $ g ^. quote) (Practice g)
    V.EvKey (V.KChar 'n') [V.MCtrl] -> startGameM Nothing (Practice g)
    V.EvKey (V.KChar _) [] -> nextState (g & strokes +~ 1)
    _ -> nextState g
  where
    nextState g' =
      if isDone g'
        then M.continue (Practice g')
        else do
          gEdited <- handleEventLensed g' input E.handleEditorEvent ev
          currentTime <- liftIO getCurrentTime
          M.continue . Practice . updateTime currentTime $ movePromptCursor gEdited
handleKeyPractice g _ = M.continue (Practice g)

theApp :: M.App GameState e ()
theApp =
  M.App
    { M.appDraw = draw,
      M.appChooseCursor = showFirstCursor,
      M.appHandleEvent = handleKey,
      M.appStartEvent = return,
      M.appAttrMap = const theMap
    }