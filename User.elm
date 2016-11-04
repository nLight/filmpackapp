module User exposing (..)

import Json.Decode as Decode exposing (Decoder, (:=))
import Html exposing (Html, a, div, text, img)
import Html.App as App
import Html.Attributes exposing (href, src)


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
