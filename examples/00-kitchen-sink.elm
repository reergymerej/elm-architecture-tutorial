module Main exposing (..)

import Html


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


model =
    0


update model =
    model


view model =
    Html.div [] [ Html.text "Hi" ]
