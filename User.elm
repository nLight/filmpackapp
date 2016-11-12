module User exposing (..)

import Html exposing (Html, a, div, text, img)
import Html.Attributes exposing (href, src)
import Http
import Json.Decode as Decode exposing (Decoder, (:=), at)
import Jsonp
import Task exposing (Task)


type alias Result a =
    { data : a
    }


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
    Jsonp.get user (apiHost ++ "/users/self/?access_token=" ++ token)


getUser : String -> String -> String -> Task Http.Error User
getUser apiHost token id =
    Jsonp.get user (apiHost ++ "/v1/users/" ++ id ++ "/?access_token=" ++ token)


view data =
    case data of
        Maybe.Just user ->
            div []
                [ div [] [ text user.username ]
                , img [ src user.profile_picture ] []
                ]

        Maybe.Nothing ->
            div [] [ text "No user data" ]


stub =
    """
    {
      "username": "redshoesphoto",
      "bio": "Medium format film photography. Vintage lenses. Film camera porn. Accidental street photography.",
      "website": "http://500px.com/DmitriyRozhkov",
      "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/13741168_1668724680119991_969969310_a.jpg",
      "full_name": "Senior Software Photographer",
      "counts": {
        "media": 652,
        "followed_by": 150,
        "follows": 159
      },
      "id": "229274478"
    }
    """
