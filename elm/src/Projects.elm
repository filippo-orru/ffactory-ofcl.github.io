module Projects exposing (Project, loadProjects, text)

import Array exposing (Array)
import Date exposing (Date)
import Time exposing (Month(..))


type alias Project =
    { title : String
    , border_color : String
    , cover_img : Maybe String
    , from : Date
    , to : Date
    , link : Maybe String
    , desc_short : String
    , desc : String
    }


loadProjects : Array Project
loadProjects =
    let
        d =
            Date.fromCalendarDate 2001 Jul 25
    in
    [ Project "daycare" "#05abfa" Nothing d d (Just "github.com/ffactory-ofcl/daycare") "My own dayplanner" "long desc Lorem impsum blablabla"
    , Project "LED Cube" "#05abfa" Nothing d d Nothing "3x3 multicolor LED Cube" "long desc Lorem impsum blablabla"
    , Project "The Ghem" "#05abfa" Nothing d d Nothing "Challenging Jump and run game." "long desc Lorem impsum blablabla"
    , Project "testing" "#05abfa" Nothing d d Nothing "blablabla" "long desc Lorem impsum blablabla"
    , Project "chat chyoa" "#05abfa" Nothing d d Nothing "Chat based choose your own adventure" "long desc Lorem impsum blablabla"
    , Project "my room" "#05abfa" Nothing d d Nothing "Modeled my own room in 3D" "long desc Lorem impsum blablabla"
    ]
        |> Array.fromList


text : List (String)
text =
    Array.map
        (\p ->
            " - " ++ p.title ++ " (" ++ Date.format "YYYY" p.to ++ "): " ++ p.desc_short
        )
        loadProjects
        |> Array.toList
