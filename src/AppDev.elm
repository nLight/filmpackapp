module AppDev exposing (..)

import Main
import Html


devFlags =
    { apiHost = "https://api.instagram.com/v1"
    , streams = Nothing
    }


main =
    Html.program
        { init = Main.init devFlags
        , view = Main.view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }
