module Main exposing (..)

import Basics exposing (toString)
import Html exposing (Html, a, div, text, img, h1)
import Html.App as App
import Html.Attributes exposing (href, src)
import Maybe
import User
import Task
import Http
import Token
import Json.Decode as Decode exposing (Decoder, (:=))


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }


getUser token =
    case token of
        Just token ->
            -- User.getUserSelf token
            case Decode.decodeString User.decoder User.stub of
              Ok user -> Task.succeed user
              Err message -> Task.fail message

        Nothing ->
            Task.fail "No token"


getToken =
    Token.getToken


init =
    ( { user = Maybe.Nothing
      , token = Maybe.Nothing
      , messages = []
      }
    , getToken `Task.andThen` getUser |> Task.perform GetUserError GetUserSuccess
    )


update msg model =
    case msg of
        GetUserSuccess user ->
            ( { model | user = Just user }, Cmd.none )

        GetUserError error ->
            ( {model | messages = ["error"]}, Cmd.none )

        SuccessToken token ->
            ( { model | token = token }, Cmd.none )

        ErrorToken message ->
            ( model, Cmd.none )


type alias Token =
    Maybe String


type alias Feed =
    List Media


type alias Stream =
    { feed : Feed
    , user : Maybe User.Model
    , token : Token
    }


type alias Model =
    { user : Maybe User.Model
    , token : Token
    , messages : List String
    }


type alias Comment =
    { text : String
    }


type alias Media =
    { src : String
    , likes : Int
    , views : Maybe Int
    , comments : List Comment
    }


type Msg
    = SuccessToken (Maybe String)
    | ErrorToken String
    | GetUserSuccess User.Model
    | GetUserError String


login_button token =
  case token of
    Just token ->
      div [][ text token ]
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
        , div [] ( List.map text model.messages)
        ]
