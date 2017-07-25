import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import WebSocket


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL

type alias Model =
  { input : String
  , messages : List String
  }


init : (Model, Cmd Msg)
init =
  -- Start with an empty input message and an empty list for the model
  (Model "" [], Cmd.none)


-- UPDATE

type Msg
  = Input String
  | Send
  | NewMessage String


update : Msg -> Model -> (Model, Cmd Msg)
update msg {input, messages} =
  case msg of
    Input newInput ->
      (Model newInput messages, Cmd.none)

    Send ->
      -- On clicking 'send', clear out the model's input property, keep what messages you already have,
      -- and send the input to the web address echo.websocket.org
      -- Clearing out the model's input property ensures that you have to type in the text field again
      -- before being able to send another message
      (Model "" messages, WebSocket.send "ws://echo.websocket.org" input)

    NewMessage str ->
      -- Keep whatever is in the input property of the model, and append the string
      -- to the list of messages on the model. Do nothing afterwards (Cmd.none)
      (Model input (str :: messages), Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  -- Keeps the websocket alive at this address after sending messages to it.
  -- Also receives any messages from the address and sends a Msg of type New Message
  -- to the update function.
  WebSocket.listen "ws://echo.websocket.org" NewMessage


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ div [] (List.map viewMessage model.messages)
    , input [onInput Input] []
    , button [onClick Send] [text "Send"]
    ]


viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]