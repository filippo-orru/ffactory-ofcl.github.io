module Main exposing (Model, Msg(..), main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)


type alias Model =
    {}


init : () -> ( Model, Cmd msg )
init () =
    ( {}, Cmd.none )



-- main : () Program Never Model Msg


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    ( model, Cmd.none )


view model =
    let
        viewPage title body =
            { title = title
            , body = body
            }
    in
    viewPage "ffactory"
        [ div [ class "" ]
            [ text "lololol" ]
        ]
