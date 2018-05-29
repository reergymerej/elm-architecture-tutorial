module Main exposing (..)

import Html exposing (Html, div, span, button, text)
import Html.Events exposing (onClick)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { result : Int
    , value : Int
    }


model =
    { result = 0
    , value = 0
    }



-- UPDATE


append : String -> String -> String
append =
    \a b ->
        a ++ b


appendInts : Int -> Int -> String
appendInts =
    \a b ->
        append (toString a) (toString b)


appendToInt : Int -> Int -> Int
appendToInt =
    \a b -> (String.toInt (appendInts a b))


type Message
    = ChangeResult
    | AppendValueOne


update : Message -> Model -> Model
update message model =
    case message of
        ChangeResult ->
            { model | result = 99 }

        AppendValueOne ->
            { model | value = (appendToInt model.value 1) }



-- VIEW


view : Model -> Html Message
view model =
    div []
        [ div []
            [ span [] [ text "value:" ]
            , span [] [ text (toString model.value) ]
            ]
        , button [ onClick AppendValueOne ] [ text "1" ]
        , div []
            [ span [] [ text "result:" ]
            , span [] [ text (toString model.result) ]
            ]
        , button [ onClick ChangeResult ] [ text "change result" ]
        ]
