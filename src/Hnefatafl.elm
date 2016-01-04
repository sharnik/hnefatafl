module Hnefatafl where

import StartApp
import Task exposing (Task)
import Signal exposing (Signal, Address)
import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (map)
import Array exposing (Array)

import Field

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

type alias ID = Int
type alias Board = Array (ID, Field.Model)
type alias Model = {board: Board, moveFrom: (Int, Int)}


-- Functions

boardSize : Int
boardSize = 11

initialModel : Model
initialModel =
  { board =
     Array.fromList
       [ (1, Field.init Field.Forbidden)
       , (2, Field.init Field.Empty)
       , (3, Field.init Field.Empty)
       , (4, Field.init Field.WhitePawn)
       , (5, Field.init Field.WhitePawn)
       , (6, Field.init Field.WhitePawn)
       , (7, Field.init Field.WhitePawn)
       , (8, Field.init Field.WhitePawn)
       , (9, Field.init Field.Empty)
       , (10, Field.init Field.Empty)
       , (11, Field.init Field.Forbidden)
       , (12, Field.init Field.Empty)
       , (13, Field.init Field.Empty)
       , (14, Field.init Field.Empty)
       , (15, Field.init Field.Empty)
       , (16, Field.init Field.Empty)
       , (17, Field.init Field.WhitePawn)
       , (18, Field.init Field.Empty)
       , (19, Field.init Field.Empty)
       , (20, Field.init Field.Empty)
       , (21, Field.init Field.Empty)
       , (22, Field.init Field.Empty)
       , (23, Field.init Field.Empty)
       , (24, Field.init Field.Empty)
       , (25, Field.init Field.Empty)
       , (26, Field.init Field.Empty)
       , (27, Field.init Field.Empty)
       , (28, Field.init Field.Empty)
       , (29, Field.init Field.Empty)
       , (30, Field.init Field.Empty)
       , (31, Field.init Field.Empty)
       , (32, Field.init Field.Empty)
       , (33, Field.init Field.Empty)
       , (34, Field.init Field.WhitePawn)
       , (35, Field.init Field.Empty)
       , (36, Field.init Field.Empty)
       , (37, Field.init Field.Empty)
       , (38, Field.init Field.Empty)
       , (39, Field.init Field.BlackPawn)
       , (40, Field.init Field.Empty)
       , (41, Field.init Field.Empty)
       , (42, Field.init Field.Empty)
       , (43, Field.init Field.Empty)
       , (44, Field.init Field.WhitePawn)
       , (45, Field.init Field.WhitePawn)
       , (46, Field.init Field.Empty)
       , (47, Field.init Field.Empty)
       , (48, Field.init Field.Empty)
       , (49, Field.init Field.BlackPawn)
       , (50, Field.init Field.BlackPawn)
       , (51, Field.init Field.BlackPawn)
       , (52, Field.init Field.Empty)
       , (53, Field.init Field.Empty)
       , (54, Field.init Field.Empty)
       , (55, Field.init Field.WhitePawn)
       , (56, Field.init Field.WhitePawn)
       , (57, Field.init Field.WhitePawn)
       , (58, Field.init Field.Empty)
       , (59, Field.init Field.BlackPawn)
       , (60, Field.init Field.BlackPawn)
       , (61, Field.init Field.King)
       , (62, Field.init Field.BlackPawn)
       , (63, Field.init Field.BlackPawn)
       , (64, Field.init Field.Empty)
       , (65, Field.init Field.WhitePawn)
       , (66, Field.init Field.WhitePawn)
       , (67, Field.init Field.WhitePawn)
       , (68, Field.init Field.Empty)
       , (69, Field.init Field.Empty)
       , (70, Field.init Field.Empty)
       , (71, Field.init Field.BlackPawn)
       , (72, Field.init Field.BlackPawn)
       , (73, Field.init Field.BlackPawn)
       , (74, Field.init Field.Empty)
       , (75, Field.init Field.Empty)
       , (76, Field.init Field.Empty)
       , (77, Field.init Field.WhitePawn)
       , (78, Field.init Field.WhitePawn)
       , (79, Field.init Field.Empty)
       , (80, Field.init Field.Empty)
       , (81, Field.init Field.Empty)
       , (82, Field.init Field.Empty)
       , (83, Field.init Field.BlackPawn)
       , (84, Field.init Field.Empty)
       , (85, Field.init Field.Empty)
       , (86, Field.init Field.Empty)
       , (87, Field.init Field.Empty)
       , (88, Field.init Field.WhitePawn)
       , (89, Field.init Field.Empty)
       , (90, Field.init Field.Empty)
       , (91, Field.init Field.Empty)
       , (92, Field.init Field.Empty)
       , (93, Field.init Field.Empty)
       , (94, Field.init Field.Empty)
       , (95, Field.init Field.Empty)
       , (96, Field.init Field.Empty)
       , (97, Field.init Field.Empty)
       , (98, Field.init Field.Empty)
       , (99, Field.init Field.Empty)
       , (100, Field.init Field.Empty)
       , (101, Field.init Field.Empty)
       , (102, Field.init Field.Empty)
       , (103, Field.init Field.Empty)
       , (104, Field.init Field.Empty)
       , (105, Field.init Field.WhitePawn)
       , (106, Field.init Field.Empty)
       , (107, Field.init Field.Empty)
       , (108, Field.init Field.Empty)
       , (109, Field.init Field.Empty)
       , (110, Field.init Field.Empty)
       , (111, Field.init Field.Forbidden)
       , (112, Field.init Field.Empty)
       , (113, Field.init Field.Empty)
       , (114, Field.init Field.WhitePawn)
       , (115, Field.init Field.WhitePawn)
       , (116, Field.init Field.WhitePawn)
       , (117, Field.init Field.WhitePawn)
       , (118, Field.init Field.WhitePawn)
       , (119, Field.init Field.Empty)
       , (120, Field.init Field.Empty)
       , (121, Field.init Field.Forbidden)
       ]
  , moveFrom = (0, 0)
  }

init : (Model, Effects Action)
init =
  (initialModel, Effects.none)


-- Update

type Action = NoOp | Modify ID Field.Action

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    NoOp -> (model, Effects.none)

    Modify id fieldAction ->
      let updateField (fieldID, fieldModel) =
        if fieldID == id then
          (fieldID, Field.update fieldAction fieldModel)
        else
          (fieldID, fieldModel)
      in 
        ( { model | board = Array.map updateField model.board }
        , Effects.none
        )


-- View

view : Address Action -> Model -> Html
view address model = drawBoard address model.board

drawBoard : Address Action -> Board -> Html
drawBoard address board =
  div [ id "board" ] (List.map (drawRow address board) [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ])

drawRow : Address Action -> Board -> Int -> Html
drawRow address board count =
  let row =
    Array.slice (count * 11) (count * 11 + 11) board
  in
    tr [] (List.map (drawField address) (Array.toList row))

drawField : Address Action -> (ID, Field.Model) -> Html
drawField address (id, fieldModel) =
  Field.view (Signal.forwardTo address (Modify id)) fieldModel
