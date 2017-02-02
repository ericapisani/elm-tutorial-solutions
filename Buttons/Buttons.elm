import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
  Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL
-- Alias Model to Int type
type alias Model = Int

-- Create a variable 'model' of type Model, and initialize it
model : Model
model =
  0


-- UPDATE
-- Message definition (will either be increment, decrement, or reset)
-- Defines how the model changes over time
type Msg = Increment | Decrement | Reset

update : Msg -> Model -> Model

-- Function definition. Returns the new value of the model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1

    Reset ->
      0

-- VIEW
-- This means that our view is producing an 'Html Msg' value (a chunk of Html that can produce Msg values)
view : Model -> Html Msg
-- view is a function that takes a model as a parameter and returns some html
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "RESET" ]
    ]
