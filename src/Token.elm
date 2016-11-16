module Token exposing (Token, getToken)

import Native.Token


type alias Token =
    Maybe String


getToken : Token
getToken =
    Native.Token.getToken ()
