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
type Field = Empty | WhitePawn | BlackPawn | King | Forbidden
type alias FieldRow = Array Field
type alias Board = Array FieldRow
type alias Model = {board: Board}


-- Functions

boardSize : Int
boardSize = 11

initialModel : Model
initialModel =
  { board =
     Array.fromList
       [ Array.fromList [ Forbidden, Empty, Empty, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, Empty, Empty, Forbidden ]
       , Array.fromList [ Empty, Empty, Empty, Empty, Empty, WhitePawn, Empty, Empty, Empty, Empty, Empty ]
       , Array.repeat boardSize Empty
       , Array.fromList [ WhitePawn, Empty, Empty, Empty, Empty, BlackPawn, Empty, Empty, Empty, Empty, WhitePawn ]
       , Array.fromList [ WhitePawn, Empty, Empty, Empty, BlackPawn, BlackPawn, BlackPawn, Empty, Empty, Empty, WhitePawn ]
       , Array.fromList [ WhitePawn, WhitePawn, Empty, BlackPawn, BlackPawn, King, BlackPawn, BlackPawn, Empty, WhitePawn, WhitePawn ]
       , Array.fromList [ WhitePawn, Empty, Empty, Empty, BlackPawn, BlackPawn, BlackPawn, Empty, Empty, Empty, WhitePawn ]
       , Array.fromList [ WhitePawn, Empty, Empty, Empty, Empty, BlackPawn, Empty, Empty, Empty, Empty, WhitePawn ]
       , Array.repeat boardSize Empty
       , Array.fromList [ Empty, Empty, Empty, Empty, Empty, WhitePawn, Empty, Empty, Empty, Empty, Empty ]
       , Array.fromList [ Forbidden, Empty, Empty, WhitePawn, WhitePawn, WhitePawn, WhitePawn, WhitePawn, Empty, Empty, Forbidden ]
       ]
  }

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
      WhitePawn -> "♙"
      BlackPawn -> "♟"
      King -> "♔"
      Forbidden -> "X"
  in
    td [] [ a [] [ text fieldText ] ]


drawRow : FieldRow -> Html
drawRow row =
  tr [] (List.map (drawField) (Array.toList row))
