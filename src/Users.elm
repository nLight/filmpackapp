module Users exposing (..)

import Instagram exposing (Result)
import Http
import Json.Decode as Decode exposing (Decoder, (:=), at)
import Task exposing (Task)


type alias Friend =
    { username : String
    , profile_picture : String
    , full_name : String
    , id : String
    }


friendDecoder =
    Decode.object4 Friend
        (at [ "data", "username" ] Decode.string)
        (at [ "data", "profile_picture" ] Decode.string)
        (at [ "data", "full_name" ] Decode.string)
        (at [ "data", "id" ] Decode.string)


friendsListDecoder : Decoder (List Friend)
friendsListDecoder =
    at [ "data" ] (Decode.list friendDecoder)


getFriends : String -> String -> Task Http.Error (List Friend)
getFriends apiHost token =
    Instagram.get apiHost token friendsListDecoder "/users/self/follows"
