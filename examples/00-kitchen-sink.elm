module Main exposing (..)

import Html
import Html.Events


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }


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
    }


type Msg
    = SetVisibilityActive
    | SetVisibilityAll
    | SetVisibilityComplete


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetVisibilityAll ->
            { model | visiblity = All }

        SetVisibilityActive ->
            { model | visiblity = Active }

        SetVisibilityComplete ->
            { model | visiblity = Completed }


renderTodoItems : TaskList -> Html.Html Msg
renderTodoItems list =
    Html.ul []
        (List.map (\item -> Html.li [] [ Html.text item.task ]) list)


renderTodoVisibilityButton : String -> Msg -> Html.Html Msg
renderTodoVisibilityButton text message =
    Html.button
        [ Html.Events.onClick message
        ]
        [ Html.text text ]


renderTodoButtons : Html.Html Msg
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


renderTodoStuff : Model -> Html.Html Msg
renderTodoStuff model =
    Html.div []
        [ renderTodoItems (filterTodoItems model.todoItems model.visiblity)
        , renderTodoButtons
        ]


renderUser : User -> Html.Html Msg
renderUser user =
    case user of
        AnonymousUser ->
            Html.div [] [ Html.text "Some Dude" ]

        NamedUser name ->
            Html.div [] [ Html.text name ]


renderUsers : UserList -> Html.Html Msg
renderUsers users =
    Html.div []
        (List.map renderUser users)


renderAnonStuff : Model -> Html.Html Msg
renderAnonStuff model =
    Html.div []
        [ renderUsers model.users
        ]


renderTitle : String -> Html.Html Msg
renderTitle title =
    Html.h3 [] [ Html.text title ]


view : Model -> Html.Html Msg
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
                ]
            ]
        ]
