module App exposing (..)

import Html
import Main


main =
    Html.programWithFlags
        { init = Main.init
        , view = Main.view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }
