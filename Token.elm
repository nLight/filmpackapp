module Token exposing (Token, getToken)

import Native.Token
import Task exposing (Task)
import Json.Decode as Decode exposing (Decoder, (:=))


type alias Token =
    Maybe String


getToken : Task x Token
getToken =
    Native.Token.getToken
