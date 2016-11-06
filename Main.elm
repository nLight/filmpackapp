module Main exposing (..)

import Basics exposing (toString)
import Html exposing (Html, a, div, text, img, h1)
import Html.App as App
import Html.Attributes exposing (href, src)
import Maybe
import User
import Task
import Http
import Token exposing (getToken)


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }


redshoesphoto_user =
    """
    {
      "username": "redshoesphoto",
      "bio": "Medium format film photography. Vintage lenses. Film camera porn. Accidental street photography.",
      "website": "http://500px.com/DmitriyRozhkov",
      "profile_picture": "https://scontent.cdninstagram.com/t51.2885-19/s150x150/13741168_1668724680119991_969969310_a.jpg",
      "full_name": "Senior Software Photographer",
      "counts": {
        "media": 652,
        "followed_by": 150,
        "follows": 159
      },
      "id": "229274478"
    }
    """


getUser token =
    case token of
        Just token ->
            User.getUserSelf token |> Task.perform GetUserError GetUserSuccess

        Nothing ->
            Cmd.none


init =
    { user = Maybe.Nothing
    , token = Maybe.Nothing
    }
        ! [ getToken |> Task.perform ErrorToken SuccessToken ]


update msg model =
    case msg of
        GetUser ->
            ( model, getUser model.token )

        GetUserSuccess user ->
            ( model, Cmd.none )

        GetUserError error ->
            ( model, Cmd.none )

        SuccessToken token ->
            ( { model | token = token }, Cmd.none )

        ErrorToken s ->
            ( model, Cmd.none )


type alias Token =
    Maybe String


type alias Feed =
    List Media


type alias Stream =
    { token : Token
    , feed : Feed
    , user : Maybe User.Model
    }


type alias Model =
    { user : Maybe User.Model
    , token : Token
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
    | GetUser
    | GetUserSuccess User.Model
    | GetUserError Http.Error


login_button =
    a [ href "https://api.instagram.com/oauth/authorize/?client_id=a59977aae66341598cb366c081e0b62d&redirect_uri=http://packfilmapp.com&response_type=token" ] [ text "+ Add account" ]


comment data =
    div [] [ text data.text ]


media data =
    div []
        [ img [ src data.src ] []
        , div [] [ text "Likes: ", text (toString data.likes) ]
        , div [] (List.map comment data.comments)
        ]


stream data =
    div []
        [ User.view data.user
          -- , div [] (List.map media data.feed)
        ]


view model =
    div []
        [ h1 [] [ text "Packfilm" ]
        , div [] [ stream model ]
        , div [] [ login_button ]
        ]
