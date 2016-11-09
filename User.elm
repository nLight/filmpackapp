port module User exposing (..)

import Html exposing (Html, div, text, img)
import Html.Attributes exposing (src)
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


port api : (String -> msg) -> Sub msg


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


sendApiRequest : String -> String -> String -> Task Http.RawError Http.Response
sendApiRequest apiHost token url =
    Http.send Http.defaultSettings
        { verb = "GET"
        , headers = [ ( "Accept", "*/*" ) ]
        , url = (apiHost ++ url ++ "&access_token=" ++ token ++ "&callback=instagramApiCallback")
        , body = Http.empty
        }


getUserSelf : String -> String -> Task Http.RawError Http.Response
getUserSelf apiHost token =
    sendApiRequest apiHost token "/users/self/?"


getUser : String -> String -> String -> Task Http.RawError Http.Response
getUser apiHost token id =
    sendApiRequest apiHost token ("/v1/users/" ++ id ++ "/?")


searchUser : String -> String -> String -> Task Http.RawError Http.Response
searchUser apiHost token query =
    sendApiRequest apiHost token ("/v1/users/search/?q=" ++ query)


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
