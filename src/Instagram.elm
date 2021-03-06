module Instagram exposing (..)

import Json.Decode as Decode exposing (Decoder, field, string, int, maybe)
import Jsonp
import Task exposing (Task)


type alias Error =
    String


type alias ResponseMeta =
    { code : Int, error_type : Maybe String, error_message : Maybe String }


type alias ResponsePagination =
    { next_url : Maybe String, next_max_id : Maybe String }


type alias ApiResponse a =
    { data : a
    , meta : ResponseMeta
    , pagination : Maybe ResponsePagination
    }


apiResponseDecoder : Decode.Decoder value -> Decode.Decoder (ApiResponse (Maybe value))
apiResponseDecoder decoder =
    Decode.map3 ApiResponse
        (maybe (field "data" decoder))
        (field "meta"
            (Decode.map3 ResponseMeta
                (field "code" int)
                (maybe (field "error_type" string))
                (maybe (field "error_message" string))
            )
        )
        (maybe
            (field "pagination"
                (Decode.map2 ResponsePagination
                    (maybe (field "next_url" Decode.string))
                    (maybe (field "next_max_id" Decode.string))
                )
            )
        )


get apiHost token decoder url_ =
    let
        requestUrl =
            (url (apiHost ++ url_) [ ( "access_token", token ) ])
    in
        Jsonp.get (apiResponseDecoder decoder) requestUrl
            |> Task.andThen (checkResponseCode)


checkResponseCode : ApiResponse (Maybe b) -> Task String (Maybe b)
checkResponseCode value =
    case value.meta.code of
        200 ->
            Task.succeed value.data

        _ ->
            Task.fail (Maybe.withDefault "Unknown Error" value.meta.error_message)


queryPair : ( String, String ) -> String
queryPair ( key, value ) =
    key ++ "=" ++ value


url : String -> List ( String, String ) -> String
url baseUrl args =
    case args of
        [] ->
            baseUrl

        _ ->
            baseUrl ++ "?" ++ String.join "&" (List.map queryPair args)
