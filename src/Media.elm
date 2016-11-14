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


mediaDecoder : Decoder Media
mediaDecoder =
    Decode.object2 Media
        (at [ "images", "standard_resolution", "url" ] Decode.string)
        (at [ "id" ] Decode.string)


mediaListDecoder : Decoder (List Media)
mediaListDecoder =
    at [ "data" ] (Decode.list mediaDecoder)


getMediaSelf : String -> String -> Task Http.Error (List Media)
getMediaSelf apiHost token =
    Instagram.get apiHost token mediaListDecoder "/users/self/media/recent"


get : String -> String -> String -> Task Http.Error (List Media)
get apiHost token id =
    Instagram.get apiHost token mediaListDecoder ("/users/" ++ id ++ "/media/recent")


view data =
    div [ class "card" ]
        [ img [ style [ ( "width", "100%" ) ], class "card-img-top", src data.url ] []
        , div [ class "card-block" ] [ text data.id ]
        ]
