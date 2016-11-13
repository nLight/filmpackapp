module Main exposing (..)

import Html exposing (Html, a, div, nav, text, img, h1)
import Html.Attributes exposing (href, src, class)
import Maybe
import Task
import Token
import Http
import User exposing (User)
import Media exposing (Media)


type alias Model =
    { apiHost : String
    , user : Maybe User
    , recent : List (Media.Media)
    , token : Token.Token
    , messages : List String
    }


type Msg
    = SuccessToken (Maybe String)
    | ErrorToken String
    | ApiError Http.Error
    | GetUserSuccess User.User
    | GetMediaSuccess Media.ApiResult
    | ApiResult String


type alias Flags =
    { apiHost : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { apiHost = flags.apiHost
      , user = Maybe.Nothing
      , recent = []
      , token = getToken
      , messages = []
      }
    , Cmd.batch
        [ (getMedia flags.apiHost getToken) |> Task.perform ApiError GetMediaSuccess
        , (getUser flags.apiHost getToken) |> Task.perform ApiError GetUserSuccess
        ]
    )


getUser apiHost token =
    case token of
        Just token ->
            User.getUserSelf apiHost token

        Nothing ->
            Task.fail (Http.UnexpectedPayload "No token")


getMedia apiHost token =
    case token of
        Just token ->
            Media.getMediaSelf apiHost token

        Nothing ->
            Task.fail (Http.UnexpectedPayload "No token")


getToken =
    Token.getToken


update msg model =
    case msg of
        SuccessToken token ->
            ( { model | token = token }, Cmd.none )

        ErrorToken message ->
            ( model, Cmd.none )

        GetUserSuccess user ->
            ( { model | user = Just user }, Cmd.none )

        GetMediaSuccess data ->
            ( { model | recent = data.data }, Cmd.none )

        _ ->
            ( model, Cmd.none )


login_button token =
    case token of
        Just token ->
            div [] []

        Nothing ->
            a
                [ class "btn btn-outline-primary"
                , href "https://api.instagram.com/oauth/authorize/?client_id=a59977aae66341598cb366c081e0b62d&redirect_uri=http://packfilmapp.com&response_type=token"
                ]
                [ text "Login" ]


stream data =
    div []
        [ User.cardView data.user
        , div [] (List.map Media.view data.recent)
        ]


messages model =
    List.map (\message -> div [ class "alert alert-danger" ] [ text message ]) model.messages


view model =
    div []
        [ nav [ class "navbar navbar-full navbar-light bg-faded navbar-static-top" ]
            [ a [ class "navbar-brand" ] [ text "Packfilm" ]
            ]
        , div [ class "container-fluid" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12" ] (messages model)
                ]
            , div [ class "row" ]
                [ div [ class "col-xs-4" ]
                    [ div [] [ stream model ]
                    , div [] [ login_button model.token ]
                    ]
                ]
            ]
        ]
