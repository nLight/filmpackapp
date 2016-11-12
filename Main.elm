module Main exposing (..)

import Html exposing (Html, a, div, text, img, h1)
import Html.Attributes exposing (href, src)
import Maybe
import Task
import Token
import User exposing (User)


type alias Model =
    { apiHost : String
    , user : Maybe User
    , token : Token.Token
    , messages : List String
    }


type Msg
    = SuccessToken (Maybe String)
    | ErrorToken String
    | ApiError String
    | ApiSuccess (Maybe User.User)
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
        [ (getUser flags.apiHost getToken) |> Task.perform ApiError GetUserSuccess
        , (getMedia flags.apiHost getToken) |> Task.perform ApiError GetMediaSuccess
        ]
    )


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

        ApiSuccess (Just user) ->
            ( { model | user = Just user }, Cmd.none )

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
        , div [] (List.map text model.messages)
        ]
