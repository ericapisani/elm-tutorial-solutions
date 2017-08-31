import Html exposing (..)
import Html.Events exposing (onClick)
import Random

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Model =
  {
    dieFace1 : Int
    , dieFace2: Int
  }

type Msg
  = Roll
  | NewFaceDie1 Int
  | NewFaceDie2 Int


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  -- Produce a random number from 1 to 6, and fire a message of type NewFace with the value
  case msg of
    Roll ->
      (model, Random.generate NewFaceDie1 (Random.int 1 6))

    NewFaceDie1 newFace ->
      ({ model | dieFace1 = newFace }, Random.generate NewFaceDie2 (Random.int 1 6))

    NewFaceDie2 newFace ->
      ({ model | dieFace2 = newFace }, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.dieFace1) ]
    , h1 [] [ text (toString model.dieFace2) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- INIT

-- Specify the initial model and commands we want to run right away
-- when the app starts
init : (Model, Cmd Msg)
init =
  (Model 1 2, Cmd.none)
