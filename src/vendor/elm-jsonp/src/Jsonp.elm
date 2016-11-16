module Jsonp exposing (jsonp, get)

{-| # Fetch JSON

@docs get

# Arbitrary requests

@docs jsonp
-}

import Json.Decode as Json
import Native.Jsonp
import Random
import Task exposing (Task)
import Time


{-| Send a GET request to the given URL. The specified `Decoder` will be
used to parse the result.
-}
get : Json.Decoder value -> String -> Task String value
get decoder url =
    let
        decode s =
            case Json.decodeString decoder s of
                Ok value ->
                    Task.succeed value

                Err message ->
                    Task.fail message
    in
        randomCallbackName
            |> Task.andThen (jsonp url)
            |> Task.andThen decode


{-| Send an arbitrary JSONP request. You will have to map the error for this `Task`
yourself, as JSONP failures cannot be captured. You will most likely be using
`Jsonp.get`. The first argument is the URL. The second argument is the callback name.
`Jsonp.get` uses a random callback name generator under the hood.
-}
jsonp : String -> String -> Task x String
jsonp =
    Native.Jsonp.jsonp


randomCallbackName : Task x String
randomCallbackName =
    let
        generator =
            Random.int 10 Random.maxInt
    in
        Time.now
            |> Task.map (round >> Random.initialSeed)
            |> Task.map (Random.step generator >> Tuple.first)
            |> Task.map (toString >> (++) "callback")
