module Media exposing (..)

import Html exposing (Html, a, div, text, img)
import Html.Attributes exposing (href, src, class)
import Http
import Json.Decode as Decode exposing (Decoder, (:=), at)
import Jsonp
import Task exposing (Task)


type alias Media =
    { url : String
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
        (at [ "images", "standard_resolution", "url" ] Decode.string)
        (at [ "id" ] Decode.string)


getMediaSelf : String -> String -> Task Http.Error ApiResult
getMediaSelf apiHost token =
    Jsonp.get data (apiHost ++ "/users/self/media/recent/?access_token=" ++ token)


view data =
    div []
        [ img [ src data.url ] []
        , div [] [ text data.id ]
        ]


stub =
    """

    """
