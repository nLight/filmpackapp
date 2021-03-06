module Media exposing (..)

import Html exposing (Html, a, div, text, img, i, strong, p)
import Html.Attributes exposing (href, src, class, style)
import Instagram
import Json.Decode as Decode exposing (Decoder, at, field)
import Task exposing (Task)


type alias Media =
    { id : String
    , created_time : String
    , url : String
    , link : String
    , likes : Int
    , user : User
    , caption : Maybe Caption
    }


type alias User =
    { id : String
    , username : String
    , profile_picture : String
    }


type alias Caption =
    { id : String
    , created_time : String
    , text : String
    , from : FromUser
    }


type alias FromUser =
    { id : String
    , username : String
    , full_name : String
    }


mediaDecoder : Decoder Media
mediaDecoder =
    Decode.map7 Media
        (field "id" Decode.string)
        (field "created_time" Decode.string)
        (at [ "images", "standard_resolution", "url" ] Decode.string)
        (field "link" Decode.string)
        (at [ "likes", "count" ] Decode.int)
        (field "user"
            (Decode.map3 User
                (at [ "id" ] Decode.string)
                (at [ "username" ] Decode.string)
                (at [ "profile_picture" ] Decode.string)
            )
        )
        (Decode.maybe
            (field "caption"
                (Decode.map4 Caption
                    (field "id" Decode.string)
                    (field "created_time" Decode.string)
                    (field "text" Decode.string)
                    (field "from"
                        (Decode.map3 FromUser
                            (field "id" Decode.string)
                            (field "username" Decode.string)
                            (field "full_name" Decode.string)
                        )
                    )
                )
            )
        )


mediaListDecoder : Decoder (List Media)
mediaListDecoder =
    Decode.list mediaDecoder


getSelf : String -> String -> Task String (Maybe (List Media))
getSelf apiHost token =
    Instagram.get apiHost token mediaListDecoder "/users/self/media/recent"


get : String -> String -> String -> Task String (Maybe (List Media))
get apiHost token id =
    Instagram.get apiHost token mediaListDecoder ("/users/" ++ id ++ "/media/recent")


compareTime a b =
    case compare a.created_time b.created_time of
        LT ->
            GT

        EQ ->
            EQ

        GT ->
            LT


caption data =
    case data of
        Just caption ->
            (p [ class "card-text" ]
                [ strong [] [ text caption.from.username ]
                , text " "
                , text caption.text
                ]
            )

        Nothing ->
            div [] []


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
        , a [ href data.link ]
            [ img [ style [ ( "width", "100%" ) ], class "card-img-top", src data.url ] []
            ]
        , div [ class "card-block" ]
            [ p [ class "card-text" ]
                [ i [ class "fa fa-heart" ] []
                , text (" " ++ (toString data.likes))
                , text " likes"
                ]
            , caption data.caption
            ]
        ]
