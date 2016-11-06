module Location exposing (Location, getLocation, decoder)

import Native.Location
import Json.Decode as Decode exposing (Decoder, (:=))


type alias Location =
    { href : String
    , host : String
    , hostname : String
    , pathname : String
    , search : String
    , hash : String
    }


decoder : Decoder Location
decoder =
    Decode.object6 Location
        ("href" := Decode.string)
        ("host" := Decode.string)
        ("hostname" := Decode.string)
        ("pathname" := Decode.string)
        ("search" := Decode.string)
        ("hash" := Decode.string)


getLocation : Platform.Task String String
getLocation =
    Native.Location.getLocation



-- getLocation : Platform.Task Maybe Location
-- getLocation =
--     case Decode.decodeString decoder location of
--         Result.Ok location ->
--             Just location
--
--         Result.Err message ->
--             Nothing
