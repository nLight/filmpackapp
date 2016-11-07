module AppDev exposing (..)

import Html.App
import Main
import Task


devFlags =
    { apiHost = "http://localhost:9000" }


init : Main.Flags -> ( Main.Model, Cmd Main.Msg )
init flags =
    ( { apiHost = flags.apiHost
      , user = Maybe.Nothing
      , token = Main.getToken
      , messages = []
      }
    , (Main.getUser flags.apiHost Main.getToken) |> Task.perform Main.GetUserError Main.GetUserSuccess
    )


main =
    Html.App.program
        { init = init devFlags
        , view = Main.view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }
