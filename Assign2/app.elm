--liuk44
--Kexin Liu
--Elm Game Application

module Main exposing (..)

import Html.Attributes as Attrt
import Html.Events exposing (onClick)
import Platform.Cmd as Cmd
import Platform.Sub as Sub
import Html exposing (..) 
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Keyboard as Key
import AnimationFrame as Anim

---------------------------------------------------

type alias Model = {
                    ball : Position
                    , block : Position 
                    , isOver : Bool
                    , ifWin : Bool
                    , menuInt : Int
                    }

type alias Position = { x : Int, y : Int }


type Msg = KeyMsg Int
         | Tick Float
         | MenuMsg
        
------------------------------------------
--init
init : (Model, Cmd Msg)

init = ({
        ball = { x = 300, y = 570 }
        , block = { x = 300, y = 300}
        , isOver = False
        , ifWin = False 
        , menuInt = 0
        }, Cmd.none )


---------------------------------------------
--update

update : Msg -> Model -> (Model, Cmd Msg)

update msg model = 
    case msg of
      KeyMsg keys -> updateBall keys model
      Tick time   -> updateBlocks time model |> updateModel
      MenuMsg     -> ({ ball = { x = 300, y = 590 }
                      , block = { x = 300, y = 300}
                      , isOver = False
                      , ifWin = False 
                      , menuInt = 1} , Cmd.none)
                           

      

ifHitBlock : (Model, Cmd Msg) -> (Model, Cmd Msg)  

ifHitBlock (model, cmd) = let

  isOver = hit model.ball model.block

 in ( { model | isOver = isOver }, cmd)



hit : Position -> Position -> Bool
hit a b = ((a.x - b.x)^2 + (a.y - b.y)^2) <= 2700
  


ifWin : (Model, Cmd Msg) -> (Model, Cmd Msg)
ifWin (model, cmd) = let

  ifWin = (model.ball.y <= 0)

 in ( { model | ifWin = ifWin }, cmd)


updateBlocks : Float -> Model -> Model
updateBlocks time model = let
  posX = round <| 300 + 245 * cos(time/300) 
  posY = round <| 270 + 245 * sin(time/300)

  modelN = { model | block = { x = posX, y = posY } }
 in (modelN)  
    
 

updateBall : Int -> Model -> ( Model, Cmd Msg )


updateBall msg model = case msg of
         38 -> ({ model | ball = { x = model.ball.x, y = model.ball.y - 20 }}, Cmd.none)
         40 -> ({ model | ball = { x = model.ball.x, y = model.ball.y + 20 }}, Cmd.none)
         37 -> ({ model | ball = { x = model.ball.x - 20, y = model.ball.y}}, Cmd.none)
         39 -> ({ model | ball = { x = model.ball.x + 20, y = model.ball.y }}, Cmd.none)
         _   -> ( model, Cmd.none )




updateModel : Model -> ( Model, Cmd Msg )
updateModel model =
    if model.isOver then
        ( model, Cmd.none )
    else
        ( model, Cmd.none )
            |> ifHitBlock
            |> ifWin


-------------------------------------------------------------
--subscription
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ keyChanged, tick]

keyChanged : Sub Msg
keyChanged =
    Key.downs KeyMsg


tick : Sub Msg
tick = Anim.times Tick


---------------------------------------------------------------
--view

menuS = Attrt.style [ ("background-color","LightCyan")
                    , ("color", "#1C82F7")
                    , ("font-size","80px")
                    , ("padding","30px 30px")
                    , ("text-align", "center")
                    ]
pS = Attrt.style [  
                     ("color","black")
                   , ("font-size","40px")
                 ]

fS = Attrt.style [  
                     ("color","black")
                   , ("font-size","20px")
                   , ("text-align", "right")
                 ]

mainMenu : Model -> Html.Html Msg
mainMenu model = div [menuS]
                     [ p [menuS] [Html.text "Welcome!"]
                     , p [pS] [Html.text "Use the arrow keys to move the small red square. Avoid getting colliding with the rotating blue ball, or the game will be over. Hope you enjoy this game!"]
                     , button [onClick MenuMsg] [Html.text "Play"]
                     , footer [fS] [Html.text "Kexin Liu"]
                     ]



gameOverM : Model -> Html.Html Msg
gameOverM model = div [menuS]
                     [ 
                     p [menuS] [Html.text "Game Over!"]
                     , button [onClick MenuMsg] [Html.text "Play Again"]
                     ]

winM : Model -> Html.Html Msg
winM model = div [menuS]
                [
                p [menuS] [Html.text "You Win!"]
                , button [onClick MenuMsg] [Html.text "Play Again"] 
                ]


play : Model ->  Html.Html Msg
play model = div []
                 [
                  svg [width "600", height "600", stroke "black"]
                      [ border
                      , blockView model.block
                      , ballView model.ball]
                 ]

border : Svg Msg
border = rect [x "0", y "0", width "600", height "600", fill "LightCyan"] []

blockView : Position -> Svg Msg
blockView block = let
  posX = toString block.x
  posY = toString block.y
 in (circle [cx posX, cy posY, r "50", fill "blue"] []) 
    

ballView : Position -> Svg Msg
ballView ball = let
  posX = toString (ball.x - 10)
  posY = toString (ball.y - 10)
 in (rect [x posX, y posY, width "20", height "20", fill "red"] [])


view : Model -> Html.Html Msg
view model = 
      if model.isOver == True 
      then gameOverM model
      else if model.ifWin == True
      then winM model
      else 
        if model.menuInt == 1
        then play model
        else mainMenu model

-----------------------------------------------------------
main : Program Never Model Msg
main = Html.program
        {init = init,
        update = update,
        view = view,
        subscriptions = subscriptions
        }
