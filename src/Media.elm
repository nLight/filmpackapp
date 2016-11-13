module Media exposing (..)

import Html exposing (Html, a, div, text, img)
import Html.Attributes exposing (href, src, class, style)
import Http
import Instagram
import Json.Decode as Decode exposing (Decoder, (:=), at)
import Task exposing (Task)


type alias Media =
    { url : String
    , id : String
    }


media : Decoder (List Media)
media =
    Decode.list
        (Decode.object2 Media
            (at [ "images", "standard_resolution", "url" ] Decode.string)
            (at [ "id" ] Decode.string)
        )


getMediaSelf : String -> String -> Task Http.Error (List Media)
getMediaSelf apiHost token =
    Instagram.get apiHost token media "/users/self/media/recent"


view data =
    div [ class "card" ]
        [ img [ style [ ( "width", "100%" ) ], class "card-img-top", src data.url ] []
        , div [ class "card-block" ] [ text data.id ]
        ]
