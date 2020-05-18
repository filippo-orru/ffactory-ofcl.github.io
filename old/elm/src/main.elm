port module Main exposing (Model, Msg(..), main)

import Array exposing (Array)
import Browser
import Date exposing (Date)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Projects exposing (Project)


type alias Model =
    { projects : ProjectsModel
    , showSplash : Bool
    , showTooltip : Bool
    , showContactOverlay : Bool
    }


type ViewState
    = SplashSection
    | ProjectsSection


type alias ProjectsModel =
    { hovering : Maybe Int
    , selected : Maybe Int
    , list : Array Project
    }


init : () -> ( Model, Cmd msg )
init () =
    ( { projects = ProjectsModel Nothing Nothing Projects.loadProjects
      , showSplash = True
      , showTooltip = False
      , showContactOverlay = False
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


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    let
        _ =
            Debug.log "msg" msg
    in
    case msg of
        KeyPress EnterKey ->
            ( { model | showSplash = not model.showSplash }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- ( model, Cmd.none )


view model =
    let
        viewPage title body =
            { title = title
            , body = body
            }
    in
    viewPage "ffactory" <|
        [ contactMe ]
            ++ viewSplash model.showSplash
            ++ viewProjects model.projects



{-
   viewCurrent state =
       case state of
           SplashSection ->
               viewSplash

           ProjectsSection projects ->
               viewProjects projects
-}


viewSplash : Bool -> List (Html Msg)
viewSplash visible =
    let
        cclass =
            if visible then
                "splash-container"

            else
                "splash-container hidden"
    in
    [ div [ class cclass ]
        [ h1 [ class "splash-header mono" ]
            [ span [] [ text ">./Filippo_Orru" ]
            , span [ class "blink" ] []
            ]
        , div [ class "splash-tooltip", onClick <| KeyPress EnterKey ] [ span [] [ text "Press Enter to begin" ] ]
        ]
    ]


viewProjects : ProjectsModel -> List (Html Msg)
viewProjects projects =
    [ div [ class "projects-wrapper" ]
        [ div [ class "projects-container" ]
            (Array.map viewProject projects.list
            |> Array.toList
            )
        ]
    ]


viewProject : Project -> Html Msg
viewProject project =
    div [ class "project" ]
        [ div [ class "project-header" ]
            [ h3 [ class "project-title" ] [ text project.title ]
            , span [ class "project-year" ] [ text <| Date.format "YYYY" project.to ]
            ]
        , div [ class "project-body" ]
            [ case project.link of
                Just link ->
                    span [ class "project-link" ] [ text link ]

                _ ->
                    text ""
            , p [ class "project-description-s" ] [ text project.desc_short ]
            ]
        ]


contactMe : Html Msg
contactMe =
    div [ class "contact-container" ]
        [ span [ class "contact-icon" ] [ text "contact Me!" ]
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
