module User exposing (..)

import Html exposing (Html, a, div, text, img)
import Html.App as App
import Html.Attributes exposing (href, src)
import Http
import Json.Decode as Decode exposing (Decoder, (:=))
import Task exposing (..)


type alias Model =
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


decoder : Decoder Model
decoder =
    Decode.object7 Model
        ("username" := Decode.string)
        ("bio" := Decode.string)
        ("website" := Decode.string)
        ("profile_picture" := Decode.string)
        ("full_name" := Decode.string)
        ("counts" := countsDecoder)
        ("id" := Decode.string)


getUserSelf : String -> String -> Task Http.Error Model
getUserSelf apiHost token =
    Http.get decoder (apiHost ++ "/users/self/?callback=instagramApiCallback&access_token=" ++ token)


getUser : String -> String -> String -> Task Http.Error Model
getUser apiHost token id =
    Http.get decoder (apiHost ++ "/v1/users/" ++ id ++ "/?callback=instagramApiCallback&access_token=" ++ token)


searchUser : String -> String -> String -> Task Http.Error (List Model)
searchUser apiHost token query =
    Http.get (Decode.list decoder) (apiHost ++ "/v1/users/search/?q=" ++ query ++ "&callback=instagramApiCallback&access_token=" ++ token)


view data =
    case data of
        Maybe.Just user ->
            div []
                [ div [] [ text user.username ]
                , img [ src user.profile_picture ] []
                ]

        Maybe.Nothing ->
            div [] []


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
