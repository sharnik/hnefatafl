module Hnefatafl where

import StartApp
import Task exposing (Task)
import Signal exposing (Signal, Address)
import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)

-- Boilerplate

app : StartApp.App Model
app =
  StartApp.start
    { init = init,
      view = view,
      update = update,
      inputs = []
    }

main : Signal Html
main =
  app.html

port tasks : Signal (Task Never ())
port tasks =
  app.tasks

-- Type declarations

type alias Model = String
type Action = NoOp

-- Functions

init : (Model, Effects Action)
init =
  ("Hello World", Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, Effects.none)

view : Address Action -> Model -> Html
view address model = drawBoard

drawBoard : Html
drawBoard =
  div [ id "board" ] (List.map (drawRow) [1..11])

drawField : Int -> Html
drawField number =
  td [] [ text (toString number)]

drawRow : Int -> Html
drawRow _ =
  tr [] (List.map (drawField) [1..11])
