module AppDev exposing (..)

import Html exposing (Html, a, div, nav, text, img, h1, h4, node, body)
import Html.Attributes exposing (href, src, class, style, charset, rel, type_, attribute)
import Main
import DevUtil


devFlags =
    { apiHost = "http://localhost:3333"
    , streams = DevUtil.getStreams
    }


main =
    Html.program
        { init = Main.init devFlags
        , view = view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }


view model =
    (node "html")
        []
        [ (node "head")
            []
            [ (node "meta") [ charset "UTF-8" ] []
            , (node "title") [] [ text "Packfilm App" ]
            , (node "link") [ rel "stylesheet", href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css", attribute "integrity" "sha384-AysaV+vQoT3kOAXZkl02PThvDr8HYKPZhNT5h/CXfBThSRXQ6jW5DO2ekP5ViFdi", attribute "crossorigin" "anonymous" ] []
            , (node "link") [ rel "stylesheet", href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css", attribute "crossorigin" "anonymous" ] []
            ]
        , body []
            [ Main.appView model
            ]
        ]
