module AppDev exposing (..)

import Html.App
import Main


devFlags =
    { apiHost = "https://api.instagram.com/v1"
    , streams = Nothing
    }


main =
    Html.App.program
        { init = Main.init devFlags
        , view = Main.view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }
