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
    , likes : Int
    , user : User
    , caption : Caption
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
    { id :
        String
        -- , userType : String
    , username : String
    , full_name : String
    }


mediaDecoder : Decoder Media
mediaDecoder =
    Decode.map6 Media
        (field "id" Decode.string)
        (field "created_time" Decode.string)
        (at [ "images", "standard_resolution", "url" ] Decode.string)
        (at [ "likes", "count" ] Decode.int)
        (field "user"
            (Decode.map3 User
                (at [ "id" ] Decode.string)
                (at [ "username" ] Decode.string)
                (at [ "profile_picture" ] Decode.string)
            )
        )
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
            [ p [ class "card-text" ]
                [ i [ class "fa fa-heart" ] []
                , text (" " ++ (toString data.likes))
                , text " likes"
                ]
            , p [ class "card-text" ]
                [ strong [] [ text data.caption.from.username ]
                , text " "
                , text data.caption.text
                ]
            ]
        ]
