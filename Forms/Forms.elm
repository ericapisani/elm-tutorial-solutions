import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String
import Regex
import Result


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , age: String
  }


model : Model
-- Set default of models within record to empty strings
model =
  Model "" "" "" ""


-- UPDATE

type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String


-- REGEX PATTERNS
-- This section creates various regex patterns by first declaring the type
-- annotation of each one (as a Regex from the Regex package), and 
-- then declaring them right after.  You have to declare them right after
-- otherwise Elm won't be happy
passwordHasUpperCaseLettersPattern : Regex.Regex
passwordHasUpperCaseLettersPattern = Regex.regex "[A-Z]"

passwordHasLowerCaseLettersPattern : Regex.Regex
passwordHasLowerCaseLettersPattern = Regex.regex "[a-z]"

passwordHasNumbersPattern : Regex.Regex
passwordHasNumbersPattern = Regex.regex "[0-9]"

update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Age age ->
      { model | age = age }

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
    , input [ type_ "text", placeholder "Age", onInput Age ] []
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
    -- Check that the age entered is an integer
      case String.toInt model.age of
        Err msg ->
          ("red", "Age is not a number!")
        Ok age ->      
          if String.length model.password <= 8 then
            ("red", "Password must be greater than 8 characters")
          else if Regex.contains passwordHasUpperCaseLettersPattern model.password == False then
            ("red", "Password must contain at least 1 uppercase letter")
          else if Regex.contains passwordHasLowerCaseLettersPattern model.password == False then
            ("red", "Password must contain at least 1 lowercase letter")
          else if Regex.contains passwordHasNumbersPattern model.password == False then
            ("red", "Password must contain at least 1 number")
          else
            if model.password == model.passwordAgain then
              ("green", "OK")
            else
              ("red", "Passwords do not match!")
  in
    div [ style [("color", color)] ] [ text message ]
