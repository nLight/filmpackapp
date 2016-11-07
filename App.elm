module App exposing (..)

import Html.App
import Main
import Task


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
    Html.App.programWithFlags
        { init = init
        , view = Main.view
        , update = Main.update
        , subscriptions = (always Sub.none)
        }
