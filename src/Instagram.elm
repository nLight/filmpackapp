module Instagram exposing (..)

import Http
import Jsonp


type alias Result a =
    { data : a
    }


get apiHost token decoder url =
    Jsonp.get decoder (Http.url (apiHost ++ url) [ ( "access_token", token ) ])
