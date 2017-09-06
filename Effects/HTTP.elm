import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode

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
    topic: String
    , gifUrl: String
    , error: String
  }

-- INIT
init : (Model, Cmd Msg)
init =
  (Model "cat" "waiting.gif" "", Cmd.none)

-- UPDATE
type Msg =
  MorePlease
  | NewGif (Result Http.Error String)   -- Result will either be an error (Http.Error) or the string of a new URL for the GIF
  | UpdateTopic String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)  -- Call the getRandomGif function, passing in the topic stored on the model

    NewGif (Ok newUrl) ->
      ({ model | gifUrl = newUrl, error = "" }, Cmd.none)  -- Update the gifUrl property with the new URL

    NewGif (Err _) ->
      ({ model | error = "There was an error fetching a new image"}, Cmd.none)  -- Don't change the model

    UpdateTopic newTopic ->
      ({ model | topic = newTopic}, Cmd.none)


-- Other function definitions
getRandomGif: String -> Cmd Msg  -- Consider this the function/method signature
getRandomGif topic =
  let
    url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic  -- Create URL
    -- Make the Http request with the URL
    -- Http.get takes a String and a JSON decoder as it's args
    -- NOTE: This doesn't actually make the Http request. It just DESCRIBES how to make the Http request
    request = Http.get url decodeGifUrl
  in
    -- Turn the Http GET request into an Elm command.
    -- The first arg is a way to turn the result of the Http request into a message for our update function.
    -- In this case, we want to send a NewGif message.
    Http.send NewGif request


optionGenerator: String -> Html msg
optionGenerator dropdownLabel =
  option [] [ text dropdownLabel ]

decodeGifUrl : Decode.Decoder String  -- Declare that decodeGifUrl is going to return a decoded (from JSON to Elm) string (I think)
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string  -- Try to find a string value at json.data.image_url


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- VIEW
view : Model -> Html Msg
view model =
  div []
    [ h2 [] [text model.topic]
    , img [src model.gifUrl] []
    , input [ placeholder "Enter a new topic", onInput UpdateTopic ] []
    , select [ onInput UpdateTopic ] [     -- Can create a helper function to create this list once it's working
      optionGenerator "Puppies"
      , optionGenerator "Kittens"
      ]
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , text model.error
    ]
