module Hnefatafl where

import StartApp
import Task exposing (Task)
import Signal exposing (Signal, Address)
import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)
import Array exposing (Array)

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

type Action = NoOp
type Field = Empty | Pawn | King
type alias FieldRow = Array Field
type alias Board = Array FieldRow
type alias Model = {board: Board}


-- Functions
boardSize : Int
boardSize = 11

initialModel : Model
initialModel =
  {board = Array.repeat boardSize (Array.repeat boardSize Empty)}

init : (Model, Effects Action)
init =
  (initialModel, Effects.none)

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, Effects.none)

view : Address Action -> Model -> Html
view address model = drawBoard model.board

drawBoard : Board -> Html
drawBoard board =
  div [ id "board" ] (List.map (drawRow) (Array.toList board))

drawField : Field -> Html
drawField field =
  let
    fieldText = case field of
      Empty -> ""
      Pawn -> "♟"
      King -> "♔"
  in
    td [] [ text fieldText ]


drawRow : FieldRow -> Html
drawRow row =
  tr [] (List.map (drawField) (Array.toList row))
