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

type Action = NoOp | Select | Deselect

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
    Deselect ->
      case model.content of
        WhitePawn ->
          { model | state = Normal }
        BlackPawn ->
          { model | state = Normal }
        King ->
          { model | state = Normal }
        _ ->
          model


-- View

type alias Context =
  { actions : Signal.Address Action
  , select : Signal.Address ()
  , deselect : Signal.Address ()
  }

view : Context -> Model -> Html
view context model =
  let
    fieldText = case model.content of
      Empty -> ""
      WhitePawn -> "♙"
      BlackPawn -> "♟"
      King -> "♔"
      Forbidden -> "X"
    fieldStyle = case model.state of
      Normal -> ""
      Selected -> "selected"
    clickAction = case model.state of
      Normal -> onClick context.select ()
      Selected -> onClick context.deselect ()
  in
    td
      [ class fieldStyle
      , clickAction
      ]
      [ a [] [ text fieldText ] ]
