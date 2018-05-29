module Main exposing (..)

import Html exposing (Html, div, button, text, input)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { value : String
    }


model =
    { value = "" }



-- UPDATE


type Msg
    = ChangeValue String


update : Msg -> Model -> Model
update msg model =
    case msg of
        ChangeValue newValue ->
            { model | value = newValue }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput ChangeValue ] []
        , div [] [ text "mirror:" ]
        , div [] [ text model.value ]
        ]
