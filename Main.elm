import Html exposing (Html, a, div, text, img, h1)
import Html.Attributes exposing (href, src)
import Html.App as App
import Html.Events exposing (onClick)
import Basics exposing (toString)
import Maybe

main =
  App.beginnerProgram { model = model, view = view, update = update }

token = Maybe.Just "1"
-- token = Maybe.Nothing

redshoesphoto =
  { token = token
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

model =
  { users = [ redshoesphoto ]
  }

update msg model =
  case msg of
    SetToken new_token ->
      {model | token = Maybe.Just new_token}

type alias Token = Maybe String

type alias Feed = List Media

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

type Msg = SetToken String

login_button =
  a [ href "http://instagram.com" ] [ text "+ Add account" ]

comment data =
  div [] [ text data.text ]

media data =
  div []
    [ img [ src data.src ] []
    , div [] [ text "Likes: ", text (toString data.likes) ]
    , div [] ( List.map comment data.comments )
    ]

app model =
  div []
    [ div [] [ text model.user.name ]
    , div [] ( List.map media model.feed )
    ]

stream data =
  case data.token of
    Maybe.Nothing ->
      login_button
    Maybe.Just token ->
      app data

view model =
  div []
    [ h1 [] [ text "Filmpack" ]
    , ( List.map stream model.users )
    ]
