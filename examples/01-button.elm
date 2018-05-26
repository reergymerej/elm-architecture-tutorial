module Main exposing (..)

import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (disabled, value)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { num : Int
    , str : String
    , valueFromServer : String
    , fetchingServerValue : Bool
    , valueToFetch : String
    }


model : Model
model =
    { num = 0
    , str = "hi"
    , valueFromServer = ""
    , fetchingServerValue = False
    , valueToFetch = ""
    }



-- UPDATE


type Msg
    = GetServerValue
    | ServerResponse
    | ChangeValueToFetch String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetServerValue ->
            ( { model
                | fetchingServerValue = True
                , valueFromServer = ""
              }
            , Cmd.none
            )

        ServerResponse ->
            ( { model
                | fetchingServerValue = False
                , valueFromServer = "a sweet fake response"
              }
            , Cmd.none
            )

        ChangeValueToFetch newValue ->
            ( { model
                | valueToFetch = newValue
              }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input
            [ onInput ChangeValueToFetch
            , value model.valueToFetch
            ]
            []
        , div [] [ text ("value from server: " ++ model.valueFromServer) ]
        , button
            [ onClick GetServerValue
            , disabled model.fetchingServerValue
            ]
            [ text "Go get server value" ]
        , button
            [ disabled (not model.fetchingServerValue)
            , onClick ServerResponse
            ]
            [ text "Fake server response" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- INIT


init : ( Model, Cmd Msg )
init =
    ( { num = 0
      , str = "hi"
      , valueFromServer = ""
      , fetchingServerValue = False
      , valueToFetch = ""
      }
    , Cmd.none
    )
