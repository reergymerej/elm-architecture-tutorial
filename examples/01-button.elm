module Main exposing (..)

import Html exposing (Html, button, div, text, input)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (disabled, value)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
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


update : Msg -> Model -> Model
update msg model =
    case msg of
        GetServerValue ->
            { model
                | fetchingServerValue = True
                , valueFromServer = ""
            }

        ServerResponse ->
            { model
                | fetchingServerValue = False
                , valueFromServer = "a sweet fake response"
            }

        ChangeValueToFetch newValue ->
            { model
                | valueToFetch = newValue
            }



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
