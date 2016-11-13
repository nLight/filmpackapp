module App exposing (..)

import Html.App
import Main


main =
    Html.App.programWithFlags
        { init = Main.init
        , view = Main.view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }
