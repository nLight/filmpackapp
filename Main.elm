module Main exposing (..)

import Html exposing (Html, a, div, text, img, h1)
import Html.Attributes exposing (href, src)
import Http
import Maybe
import Task
import Token
import User


type alias Model =
    { apiHost : String
    , user : Maybe User.Model
    , token : Token.Token
    , messages : List String
    }


type Msg
    = SuccessToken (Maybe String)
    | ErrorToken String
    | ApiError String
    | ApiSuccess (Maybe Http.Response)
    | ApiResult String


getUser apiHost token =
    case token of
        Just token ->
            Task.toMaybe (User.getUserSelf apiHost token)

        Nothing ->
            Task.fail "No token"


getToken =
    Token.getToken


type alias Flags =
    { apiHost : String
    }


update msg model =
    case msg of
        SuccessToken token ->
            ( { model | token = token }, Cmd.none )

        ErrorToken message ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


login_button token =
    case token of
        Just token ->
            div [] [ text token ]

        Nothing ->
            a [ href "https://api.instagram.com/oauth/authorize/?client_id=a59977aae66341598cb366c081e0b62d&redirect_uri=http://packfilmapp.com&response_type=token" ] [ text "Login" ]


stream data =
    div []
        [ User.view data.user
          -- , div [] (List.map media data.feed)
        ]


view model =
    div []
        [ h1 [] [ text "Packfilm" ]
        , div [] [ stream model ]
        , div [] [ login_button model.token ]
        , div [] (List.map text model.messages)
        ]
