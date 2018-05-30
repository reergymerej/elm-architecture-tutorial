module Main exposing (..)

import Html
import Html.Events


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



{-
   > our view function is producing a Html Msg value. This means that it is a chunk of HTML that can produce Msg values.
   https://guide.elm-lang.org/architecture/user_input/buttons.html
-}


type alias Markup =
    Html.Html Msg


type alias Task =
    { task : String
    , complete : Bool
    }


type Visibility
    = All
    | Active
    | Completed


type alias TaskList =
    List Task


type User
    = AnonymousUser
    | NamedUser String


type alias UserList =
    List User


type alias Model =
    { todoItems : TaskList
    , visiblity : Visibility
    , users : UserList
    , count : Int
    }


model : Model
model =
    { todoItems =
        [ { task = "Buy milk"
          , complete = True
          }
        , { task = "Drink milk"
          , complete = False
          }
        ]
    , visiblity = All
    , users =
        [ AnonymousUser
        , AnonymousUser
        , NamedUser "AzureDiamond"
        , NamedUser "Mr. Boop"
        , AnonymousUser
        ]
    , count = 0
    }


type Msg
    = SetVisibilityActive
    | SetVisibilityAll
    | SetVisibilityComplete
    | IncreaseCount
    | DecreaseCount


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetVisibilityAll ->
            { model | visiblity = All }

        SetVisibilityActive ->
            { model | visiblity = Active }

        SetVisibilityComplete ->
            { model | visiblity = Completed }

        IncreaseCount ->
            { model | count = model.count + 1 }

        DecreaseCount ->
            { model | count = model.count - 1 }


renderTodoItems : TaskList -> Markup
renderTodoItems list =
    Html.ul []
        (List.map (\item -> Html.li [] [ Html.text item.task ]) list)


renderTodoVisibilityButton : String -> Msg -> Markup
renderTodoVisibilityButton text message =
    Html.button
        [ Html.Events.onClick message
        ]
        [ Html.text text ]


renderTodoButtons : Markup
renderTodoButtons =
    Html.div []
        [ renderTodoVisibilityButton "Show All" SetVisibilityAll
        , renderTodoVisibilityButton "Show Active" SetVisibilityActive
        , renderTodoVisibilityButton "Show Completed" SetVisibilityComplete
        ]


filterTodoItems : TaskList -> Visibility -> TaskList
filterTodoItems taskList visibility =
    case visibility of
        All ->
            taskList

        Active ->
            List.filter (\task -> task.complete == False) taskList

        Completed ->
            List.filter (\task -> task.complete == True) taskList


renderTodoStuff : Model -> Markup
renderTodoStuff model =
    Html.div []
        [ renderTodoItems (filterTodoItems model.todoItems model.visiblity)
        , renderTodoButtons
        ]


renderUser : User -> Markup
renderUser user =
    case user of
        AnonymousUser ->
            Html.div [] [ Html.text "Some Dude" ]

        NamedUser name ->
            Html.div [] [ Html.text name ]


renderUsers : UserList -> Markup
renderUsers users =
    Html.div []
        (List.map renderUser users)


renderAnonStuff : Model -> Markup
renderAnonStuff model =
    Html.div []
        [ renderUsers model.users
        ]


renderTitle : String -> Markup
renderTitle title =
    Html.h3 [] [ Html.text title ]


renderCountButton : Msg -> String -> Markup
renderCountButton message label =
    Html.button [ Html.Events.onClick message ] [ Html.text label ]


renderCounterStuff : Model -> Markup
renderCounterStuff model =
    Html.div []
        [ Html.div []
            [ Html.span [] [ Html.text "count: " ]
            , Html.span [] [ Html.text (toString model.count) ]
            , Html.div []
                [ renderCountButton DecreaseCount "down"
                , renderCountButton IncreaseCount "up"
                ]
            ]
        ]


view : Model -> Markup
view model =
    Html.div []
        [ Html.h1 [] [ Html.text "Kitchen Sink" ]
        , Html.div []
            [ Html.h2 [] [ Html.text "Union Types" ]
            , Html.div []
                [ renderTitle "todo list"
                , renderTodoStuff model
                , renderTitle "anonymous user"
                , renderAnonStuff model
                , renderTitle "A Simple Counter"
                , renderCounterStuff model
                ]
            ]
        ]
