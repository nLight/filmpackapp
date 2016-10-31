module Main exposing (..)

import Html exposing (Html, a, div, text, img, h1)
import Html.Attributes exposing (href, src)
import Html.App as App
import Html.Events exposing (onClick)
import Basics exposing (toString)
import Maybe


main : Program (Maybe Model)
main =
    App.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : Maybe Model -> ( Model, Cmd Msg )
init savedModel =
    Maybe.withDefault emptyModel savedModel ! []


redshoesphoto =
    { token = Maybe.Just "1"
    , user = user
    , feed =
        [ { src = "photo_1"
          , likes = 100
          , views = Maybe.Nothing
          , comments =
                [ { text = "Hey!"
                  }
                , { text = "One more comment"
                  }
                ]
          }
        , { src = "photo_2"
          , likes = 0
          , views = Maybe.Just 12
          , comments = []
          }
        ]
    }


emptyModel =
    { users = []
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetToken new_token ->
            model ! []


type alias Token =
    Maybe String


type alias Feed =
    List Media


type alias Stream =
    { token : Token
    , feed : Feed
    , user : User
    }


type alias Model =
    { users : List Stream
    }


type alias User =
    { name : String
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


user : User
user =
    { name = "redshoesphoto" }


type Msg
    = SetToken String


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


app model =
    div []
        [ div [] [ text model.user.name ]
        , div [] (List.map media model.feed)
        ]


stream data =
    case data.token of
        Maybe.Nothing ->
            login_button

        Maybe.Just token ->
            app data


view model =
    div []
        [ h1 [] [ text "Packfilm" ]
        , div [] (List.map stream model.users)
        , div [] [ login_button ]
        ]
