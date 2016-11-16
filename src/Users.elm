module Users exposing (..)

import Instagram exposing (Result)
import Json.Decode as Decode exposing (Decoder, at)
import Task exposing (Task)


type alias Friend =
    { username : String
    , profile_picture : String
    , full_name : String
    , id : String
    }


friendDecoder =
    Decode.map4 Friend
        (at [ "username" ] Decode.string)
        (at [ "profile_picture" ] Decode.string)
        (at [ "full_name" ] Decode.string)
        (at [ "id" ] Decode.string)


friendsListDecoder : Decoder (List Friend)
friendsListDecoder =
    at [ "data" ] (Decode.list friendDecoder)


getFriends : String -> String -> Task String (List Friend)
getFriends apiHost token =
    Instagram.get apiHost token friendsListDecoder "/users/self/follows"
