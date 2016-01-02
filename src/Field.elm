module Field where

import Signal exposing (Signal, Address)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- Model

type Content = Empty | WhitePawn | BlackPawn | King | Forbidden
type State = Normal | Selected

type alias Model = { content: Content, state: State }

init : Content -> Model
init content =
  { content = content
  , state = Normal }


-- Update

type Action = NoOp | Select

update : Action -> Model -> Model
update action model =
  case action of
    NoOp ->
      model
    Select ->
      case model.content of
        WhitePawn ->
          { model | state = Selected }
        BlackPawn ->
          { model | state = Selected }
        King ->
          { model | state = Selected }
        _ ->
          model


-- View

normalStyle : Attribute
normalStyle =
  style [ ("backgroundColor", "blue") ]
        
selectedStyle : Attribute
selectedStyle =
  style [ ("backgroundColor", "red") ]

view : Signal.Address Action -> Model -> Html
view address model =
  let
    fieldText = case model.content of
      Empty -> ""
      WhitePawn -> "♙"
      BlackPawn -> "♟"
      King -> "♔"
      Forbidden -> "X"
    fieldStyle = case model.state of
      Normal -> normalStyle
      Selected -> selectedStyle
      
  in
    td
      [ fieldStyle
      , onClick address Select
      ]
      [ a [] [ text fieldText ] ]
