module Main exposing (..)

import Html
import Html.Attributes
import Html.Events


type alias Model =
    { todoItems : TaskList
    , visiblity : Visibility
    , users : UserList
    , count : Int
    , textReverseInput : String
    , formName : String
    , formPassword : String
    , formPasswordConfirmation : String
    }


type Msg
    = SetVisibilityActive
    | SetVisibilityAll
    | SetVisibilityComplete
    | IncreaseCount
    | DecreaseCount
    | ResetCount
    | ChangeTextReverseInput String
    | FormChangeName String
    | FormChangePassword String
    | FormChangePasswordConfirmation String


main : Program Never Model Msg
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
    , textReverseInput = ""
    , formName = ""
    , formPassword = ""
    , formPasswordConfirmation = ""
    }


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

        ResetCount ->
            { model | count = 0 }

        ChangeTextReverseInput value ->
            { model | textReverseInput = value }

        FormChangeName name ->
            { model | formName = name }

        FormChangePassword password ->
            { model | formPassword = password }

        FormChangePasswordConfirmation password ->
            { model | formPasswordConfirmation = password }


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


renderClickableButton : Msg -> String -> Markup
renderClickableButton message label =
    Html.button [ Html.Events.onClick message ] [ Html.text label ]


renderCounterStuff : Model -> Markup
renderCounterStuff model =
    Html.div []
        [ Html.div []
            [ Html.span [] [ Html.text "count: " ]
            , Html.span [] [ Html.text (toString model.count) ]
            , Html.div []
                [ renderClickableButton DecreaseCount "down"
                , renderClickableButton IncreaseCount "up"
                , renderClickableButton ResetCount "reset"
                ]
            ]
        ]


reverseString : String -> String
reverseString input =
    String.reverse input


renderTextReverseStuff : Model -> Markup
renderTextReverseStuff model =
    Html.div []
        [ Html.input [ Html.Events.onInput ChangeTextReverseInput ] []
        , Html.div [] [ Html.text (reverseString model.textReverseInput) ]
        ]



-- renderFormField : String -> Msg String -> Markup


renderFormField placeholder onInputMessage =
    Html.div []
        [ Html.label [] [ Html.text placeholder ]
        , Html.input
            [ Html.Attributes.placeholder placeholder
            , Html.Events.onInput onInputMessage
            ]
            []
        ]


passwordsAreOK : String -> String -> Bool
passwordsAreOK a b =
    a == b


getPasswordValidationText : Model -> String
getPasswordValidationText model =
    if passwordsAreOK model.formPassword model.formPasswordConfirmation then
        "Good"
    else
        "Bad"


renderFormValidation : Model -> Markup
renderFormValidation model =
    Html.div []
        [ Html.text (getPasswordValidationText model)
        ]


renderFormStuff : Model -> Markup
renderFormStuff model =
    Html.div []
        [ renderFormField "Name" FormChangeName
        , renderFormField "Password" FormChangePassword
        , renderFormField "Password Confirmation" FormChangePasswordConfirmation
        , renderFormValidation model
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
                , renderTitle "Text Reverse"
                , renderTextReverseStuff model
                , renderTitle "Form Section"
                , renderFormStuff model
                ]
            ]
        ]
