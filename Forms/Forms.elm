import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  }


model : Model
-- Set default of models within record to empty strings
model =
  Model "" "" ""


-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }


-- VIEW

view : Model -> Html Msg
view model =
  -- First braces are the tag contents (e.g: class='' style='')
  -- Second braces is where the content goes
  -- E.g:
  -- <div> ----> First braces
  --  Hello ----> Second braces
  -- </div>
  div []
    [ input [ type_ "text", placeholder "Name", onInput Name ] []
    , input [ type_ "password", placeholder "Password", onInput Password ] []
    , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
    , viewValidation model   -- call function passing in the current model
    ]

-- This function is not creating a chunk of HTML that can produce message values
-- like the `view` function, but just regular HTML (notice the change in case on `msg`)
viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if String.length model.password <= 8 then
        ("red", "Password must be greater than 8 characters")
      else
        if model.password == model.passwordAgain then
          ("green", "OK")
        else
          ("red", "Passwords do not match!")
  in
    div [ style [("color", color)] ] [ text message ]
