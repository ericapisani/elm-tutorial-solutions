import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


-- MODEL
type alias Model =
  {
    dieFace : Int
  }

type Msg
  = Roll
  | NewFace Int


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Random.generate NewFace (Random.int 1 6))

    NewFace ->
      (Model newFace, Cmd.none)


-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ h1 [] [ text (toString model.dieFace) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]


-- INIT

-- Specify the initial model and commands we want to run right away
-- when the app starts
init : (Model, Cmd Msg)
init =
  (Model 1, Cmd.none)
