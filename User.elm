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


getUserSelf : String -> Task Http.Error (Model)
getUserSelf token =
    Http.get decoder ("https://api.instagram.com/v1/users/self/?access_token=" ++ token)


getUser : String -> String -> Task Http.Error (Model)
getUser token id =
    Http.get decoder ("https://api.instagram.com/v1/users/" ++ id ++ "/?access_token=" ++ token)


searchUser : String -> String -> Task Http.Error (List Model)
searchUser token query =
    Http.get (Decode.list decoder) ("https://api.instagram.com/v1/users/search/?q=" ++ query ++ "&access_token=" ++ token)


view data =
    case data of
        Maybe.Just user ->
            div []
                [ div []
                    [ text user.username ]
                , img [ src user.profile_picture ] []
                ]

        Maybe.Nothing ->
            div [] []
