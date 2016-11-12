module Media exposing (..)

import Html exposing (Html, a, div, text, img)
import Html.Attributes exposing (href, src, class)
import Http
import Json.Decode as Decode exposing (Decoder, (:=), at)
import Jsonp
import Task exposing (Task)


type alias Media =
    { standard_resolution : String
    , id : String
    }


type alias ApiResult =
    { data : List Media }


data : Decoder ApiResult
data =
    Decode.object1 ApiResult
        ("data" := Decode.list media)


media : Decoder Media
media =
    Decode.object2 Media
        (at [ "data", "id" ] Decode.string)
        (at [ "data", "images", "standard_resolution" ] Decode.string)


getMediaSelf : String -> String -> Task Http.Error ApiResult
getMediaSelf apiHost token =
    Jsonp.get data (apiHost ++ "/users/self/media/recent/?access_token=" ++ token)


view data =
    div []
        [ img [ src data.standard_resolution ] []
        ]


stub =
    """

    """
