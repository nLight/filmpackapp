module Instagram exposing (..)

import Jsonp


type alias Error =
    String


type alias Result a =
    { data : a
    }


get apiHost token decoder url_ =
    Jsonp.get decoder (url (apiHost ++ url_) [ ( "access_token", token ) ])


queryPair : ( String, String ) -> String
queryPair ( key, value ) =
    key ++ "=" ++ value


url : String -> List ( String, String ) -> String
url baseUrl args =
    case args of
        [] ->
            baseUrl

        _ ->
            baseUrl ++ "?" ++ String.join "&" (List.map queryPair args)
