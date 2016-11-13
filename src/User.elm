module User exposing (User, cardView, getUserSelf)

import Html exposing (Html, a, div, text, img, h4, small, br)
import Html.Attributes exposing (href, src, class, style)
import Http
import Instagram
import Json.Decode as Decode exposing (Decoder, (:=), at)
import Jsonp
import Task exposing (Task)


type alias User =
    { username : String
    , bio : String
    , website : String
    , profile_picture : String
    , full_name : String
    , counts : UserCounts
    , id : String
    }


type alias UserCounts =
    { media : Int
    , followed_by : Int
    , follows : Int
    }


countsDecoder : Decoder UserCounts
countsDecoder =
    Decode.object3 UserCounts
        ("media" := Decode.int)
        ("followed_by" := Decode.int)
        ("follows" := Decode.int)


user : Decoder User
user =
    Decode.object7 User
        (at [ "data", "username" ] Decode.string)
        (at [ "data", "bio" ] Decode.string)
        (at [ "data", "website" ] Decode.string)
        (at [ "data", "profile_picture" ] Decode.string)
        (at [ "data", "full_name" ] Decode.string)
        (at [ "data", "counts" ] countsDecoder)
        (at [ "data", "id" ] Decode.string)


getUserSelf : String -> String -> Task Http.Error User
getUserSelf apiHost token =
    Instagram.get apiHost token user "/users/self"


getUser : String -> String -> String -> Task Http.Error User
getUser apiHost token id =
    Instagram.get apiHost token user ("/v1/users/" ++ id)


countsView data =
    div [ class "" ]
        [ div [ class "row" ]
            [ div [ class "col-xs-4" ]
                [ div [] [ text (toString data.media) ]
                , small [] [ text "posts" ]
                ]
            , div [ class "col-xs-4" ]
                [ div [] [ text (toString data.followed_by) ]
                , small [] [ text "followers" ]
                ]
            , div [ class "col-xs-4" ]
                [ div [] [ text (toString data.follows) ]
                , small [] [ text "follows" ]
                ]
            ]
        ]


cardView data =
    case data of
        Maybe.Just user ->
            div [ class "media", style [ ( "margin", "30px 0" ) ] ]
                [ a [ class "media-left" ] [ img [ style [ ( "width", "100px" ) ], class "rounded-circle", src user.profile_picture ] [] ]
                , div [ class "media-body" ]
                    [ h4 [ class "media-heading" ] [ text user.username ]
                    , countsView user.counts
                    ]
                ]

        Maybe.Nothing ->
            div [] []
