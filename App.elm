module App exposing (..)

import Html.App
import Main
import Task
import User


init : Main.Flags -> ( Main.Model, Cmd Main.Msg )
init flags =
    ( { apiHost = flags.apiHost
      , user = Maybe.Nothing
      , token = Main.getToken
      , messages = []
      }
    , (Main.getUser flags.apiHost Main.getToken) |> Task.perform Main.ApiError Main.ApiSuccess
    )


main =
    Html.App.programWithFlags
        { init = init
        , view = Main.view
        , update = Main.update
        , subscriptions = subscriptions
        }


subscriptions : Main.Model -> Sub Main.Msg
subscriptions model =
    User.api Main.ApiResult
