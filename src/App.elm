module App exposing (..)

import Html exposing (Html, a, div, nav, text, img, h1, h4, node, body)
import Html.Attributes exposing (href, src, class, style, charset, rel, type_, attribute)
import Main


main =
    Html.programWithFlags
        { init = Main.init
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
            , (node "title") [] [ text "Packfilm App - all your Instagram accounts on one page" ]
            , (node "script") [ type_ "text/javascript", src "static/elm.js" ] []
            , (node "link") [ rel "stylesheet", href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css", attribute "integrity" "sha384-AysaV+vQoT3kOAXZkl02PThvDr8HYKPZhNT5h/CXfBThSRXQ6jW5DO2ekP5ViFdi", attribute "crossorigin" "anonymous" ] []
            , (node "link") [ rel "stylesheet", href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css", attribute "crossorigin" "anonymous" ] []
            ]
        , body []
            [ Main.appView model
            ]
        ]
