module Media exposing (..)

import Html exposing (Html, a, div, text, img, i)
import Html.Attributes exposing (href, src, class, style)
import Instagram
import Json.Decode as Decode exposing (Decoder, at)
import Task exposing (Task)


type alias Media =
    { url : String
    , created_time : String
    , id : String
    , user : User
    , likes : Int
    }


type alias User =
    { username : String
    , profile_picture : String
    , id : String
    }


mediaDecoder : Decoder Media
mediaDecoder =
    Decode.map5 Media
        (at [ "images", "standard_resolution", "url" ] Decode.string)
        (at [ "created_time" ] Decode.string)
        (at [ "id" ] Decode.string)
        (at [ "user" ]
            (Decode.map3
                User
                (at [ "username" ] Decode.string)
                (at [ "profile_picture" ] Decode.string)
                (at [ "id" ] Decode.string)
            )
        )
        (at [ "likes", "count" ] Decode.int)


mediaListDecoder : Decoder (List Media)
mediaListDecoder =
    Decode.list mediaDecoder


getSelf : String -> String -> Task String (Maybe (List Media))
getSelf apiHost token =
    Instagram.get apiHost token mediaListDecoder "/users/self/media/recent"


get : String -> String -> String -> Task String (Maybe (List Media))
get apiHost token id =
    Instagram.get apiHost token mediaListDecoder ("/users/" ++ id ++ "/media/recent")


view data =
    div [ class "card" ]
        [ div [ class "card-block" ]
            [ img
                [ class "rounded-circle"
                , style [ ( "width", "50px" ), ( "margin-right", "15px" ) ]
                , src data.user.profile_picture
                ]
                []
            , text data.user.username
            ]
        , img [ style [ ( "width", "100%" ) ], class "card-img-top", src data.url ] []
        , div [ class "card-block" ]
            [ i [ class "fa fa-heart" ] []
            , text (" " ++ (toString data.likes))
            , text " likes"
            ]
        ]
