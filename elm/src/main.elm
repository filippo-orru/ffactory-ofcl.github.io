port module Main exposing (Model, Msg(..), main)

import Array exposing (Array)
import Browser
import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Projects exposing (Project)


type alias Model =
    { -- projects : ProjectsModel
      -- , showSplash : Bool
      showTooltip : Bool
    , showContactOverlay : Bool
    , suggestions : List ValidResponse
    , messages : List Message
    , writing : String
    }


type alias Message =
    { content : List String
    , response : Bool
    }


type alias ProjectsModel =
    { hovering : Maybe Int
    , selected : Maybe Int
    , list : Array Project
    }


init : () -> ( Model, Cmd msg )
init () =
    ( { --  projects = ProjectsModel Nothing Nothing Projects.loadProjects
        showTooltip = False
      , showContactOverlay = False
      , suggestions = [ RProjects, RAbout, RContact, RSkip ]
      , messages = []
      , writing = ""
      }
    , Cmd.none
    )


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> subscriptions
        }


type ValidResponse
    = RProjects
    | RContact
    | RAbout
    | RView String
    | RSkip


type KeyPress
    = EnterKey
    | UpKey
    | DownKey


type Msg
    = Hover Int
    | Select Int
    | Submit
    | ToggleContact
    | HideTooltip
    | KeyPress KeyPress
    | UpdateWriting String
    | ClickSuggestion ValidResponse


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        _ =
            Debug.log "msg" msg
    in
    case msg of
        KeyPress EnterKey ->
            -- ( { model | showSplash = not model.showSplash }, Cmd.none )
            update Submit model

        UpdateWriting m ->
            ( { model | writing = m }, Cmd.none )

        Submit ->
            let
                messages =
                    model.messages ++ [ Message [ model.writing ] False, generateResponse model.suggestions model.writing ]
            in
            if model.writing /= "" then
                ( { model | messages = messages, writing = "" }, Cmd.none )

            else
                ( model, Cmd.none )

        ClickSuggestion sugg ->
            update Submit <| Tuple.first (update (UpdateWriting <| responseToString sugg) model)

        _ ->
            ( model, Cmd.none )


generateResponse : List ValidResponse -> String -> Message
generateResponse suggestions writing =
    let
        maybewriting =
            responseFromString writing

        response =
            case maybewriting of
                Just RProjects ->
                    Projects.text

                Just RContact ->
                    [ "Contact me at ffactory@outlook.de" ]

                Just RAbout ->
                    [ "I'm a web developer working mostly in elm!" ]

                Just (RView name) ->
                    [ "information about project \"" ++ name ++ "\"" ]

                Just RSkip ->
                    [ "loading..." ]

                Nothing ->
                    [ "invalid command \"" ++ writing ++ "\"" ]
    in
    Message response True


responseFromString : String -> Maybe ValidResponse
responseFromString writing =
    let
        splitwriting =
            String.split " " writing
    in
    case List.head splitwriting of
        Just "about" ->
            Just RAbout

        Just "contact" ->
            Just RContact

        Just "projects" ->
            Just RProjects

        Just "view" ->
            case List.tail splitwriting of
                Just tail ->
                    Just (RView <| String.join " " tail)

                Nothing ->
                    Just (RView "")

        _ ->
            Nothing


responseToString : ValidResponse -> String
responseToString response =
    case response of
        RProjects ->
            "projects"

        RAbout ->
            "about"

        RContact ->
            "contact"

        RSkip ->
            "skip"

        RView _ ->
            "view <project>"



-- ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    let
        viewPage title body =
            { title = title
            , body = [ div [ class "body" ] body ]
            }
    in
    viewPage "ffactory" <|
        [ contactMe
        , viewBottomBar model.suggestions model.writing
        , viewWindow model.messages
        ]


viewBottomBar : List ValidResponse -> String -> Html Msg
viewBottomBar suggestions writing =
    div [ class "bottombar-wrapper mono" ]
        [ div [ class "suggestions" ] <|
            List.map (\s -> div [ class "suggestion", onClick (ClickSuggestion s) ] [ text <| responseToString s ]) suggestions
        , Html.form [ onSubmit Submit ]
            [ input [ class "bottombar mono", onInput UpdateWriting, placeholder "type your command", value writing ]
                []

            -- [ button [ class "fas fa-check" ] [ text ">" ] ]
            ]
        ]


viewWindow : List Message -> Html Msg
viewWindow messages =
    div [ class "window-wrapper" ] <|
        List.map viewMessage messages


viewMessage : Message -> Html Msg
viewMessage message =
    div [ class "message mono" ] <|
        if message.response then
            List.map (\m -> span [ class "message-line" ] [ text m ]) message.content

        else
            List.map (\m -> span [ class "message-line" ] [ text m ]) <| [ "visitor@server > " ] ++ message.content


contactMe : Html Msg
contactMe =
    div [ class "contact-container" ]
        [ span [ class "contact-icon" ] [ text "Contact me!" ]
        ]


port enter : (() -> msg) -> Sub msg


port up : (() -> msg) -> Sub msg


port down : (() -> msg) -> Sub msg


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ enter (\_ -> KeyPress <| EnterKey)
        , up (\_ -> KeyPress <| UpKey)
        , down (\_ -> KeyPress <| DownKey)
        ]
