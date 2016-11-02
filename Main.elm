module Main exposing (..)

import Html exposing (Html, a, div, text, img, h1)
import Html.Attributes exposing (href, src)
import Html.App as App
import Html.Events exposing (onClick)
import Basics exposing (toString)
import Maybe


main =
    App.beginnerProgram { model = model, view = view, update = update }


token =
    Maybe.Just "229274478.a59977a.c545ddf8725c4e12a5f5fd0855cc1d1c"


redshoesphoto_user =
    { username = "redshoesphoto"
    , bio = "Medium format film photography. Vintage lenses. Film camera porn. Accidental street photography."
    , website = "http://500px.com/DmitriyRozhkov"
    , profile_picture = "https://scontent.cdninstagram.com/t51.2885-19/s150x150/13741168_1668724680119991_969969310_a.jpg"
    , full_name = "Senior Software Photographer"
    , counts =
        { media = 652
        , followed_by = 150
        , follows = 159
        }
    , id = "229274478"
    }


redshoesphoto =
    { token = token
    , user = redshoesphoto_user
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


model =
    { users = [ redshoesphoto ]
    }


update msg model =
    case msg of
        SetToken new_token ->
            { model | token = Maybe.Just new_token }


type alias Token =
    Maybe String


type alias Feed =
    List Media
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


type alias UserCounts =
    { media : Int
    , followed_by : Int
    , follows : Int
    }


type alias User =
    { username : String
    , bio : String
    , website : String
    , profile_picture : String
    , full_name : String
    , counts : UserCounts
    , id : String
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


app data =
    div []
        [ div [] [ text data.user.username ]
        , div [] (List.map media data.feed)
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
