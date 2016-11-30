module AppDev exposing (..)

import Main
import Html
import DevUtil


devFlags =
    { apiHost = "https://api.instagram.com/v1"
    , streams = DevUtil.getStreams
    }


main =
    Html.program
        { init = Main.init devFlags
        , view = Main.view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }
