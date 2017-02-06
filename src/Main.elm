port module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (Html, a, div, nav, text, img, h1, h4, node, body)
import Html.Attributes exposing (href, src, class, style, charset, rel, type_, attribute)
import Maybe
import Media exposing (Media)
import Task
import Token
import User exposing (User)
import Users


port saveToken : String -> Cmd msg


type alias Model =
    { apiHost : String
    , streams : Dict String Stream
    , messages : List String
    }


type Msg
    = ApiError String
    | GenericError String
    | GetFeedSuccess String (List (Maybe (List Media)))
    | GetMediaSuccess String (List Media)
    | GetUserSuccess String User.User
    | SilentError String
    | SuccessStreams
    | SuccessToken String


type alias Flags =
    { apiHost : String
    , streams : Maybe (List ( String, Stream ))
    }


type alias Stream =
    { user : Maybe User
    , recent : List Media.Media
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        streams =
            Dict.fromList (Maybe.withDefault [] flags.streams)

        apiHost =
            flags.apiHost

        getTokenTask =
            case Token.getToken of
                Just token ->
                    Task.succeed token

                Nothing ->
                    Task.fail ":("

        mapToken result =
            case result of
                Ok token ->
                    SuccessToken token

                Err message ->
                    SilentError message
    in
        ( { apiHost = apiHost
          , streams = streams
          , messages = []
          }
        , Cmd.batch
            ([ Task.attempt mapToken getTokenTask ]
                ++ (loadStreams apiHost streams)
            )
        )


update msg model =
    case msg of
        SuccessToken token ->
            let
                streams =
                    (Dict.insert token emptyStream model.streams)
            in
                ( { model | streams = streams }
                , Cmd.batch
                    ([ (saveToken token)
                     ]
                        ++ (loadStreams model.apiHost streams)
                    )
                )

        GetFeedSuccess token list ->
            ( updateStream model token (updateStreamFeed list), Cmd.none )

        GetUserSuccess token user ->
            ( updateStream model token (updateStreamUser user), Cmd.none )

        GetMediaSuccess token recent ->
            ( updateStream model token (updateStreamRecent recent), Cmd.none )

        GenericError error ->
            ( { model | messages = [ error ] }, Cmd.none )

        ApiError error ->
            ( { model | messages = [ error ] }, Cmd.none )

        _ ->
            ( model, Cmd.none )


mapUserResult token result =
    case result of
        Ok (Just user) ->
            GetUserSuccess token user

        Ok Nothing ->
            ApiError "No user"

        Err message ->
            ApiError message


mapMediaResult token result =
    case result of
        Ok media ->
            GetMediaSuccess token media

        Err message ->
            ApiError message


mapFeedResult token result =
    case result of
        Ok media ->
            GetFeedSuccess token media

        Err message ->
            ApiError message


loadFeed apiHost token =
    let
        mapFriends friends =
            case friends of
                Just friends ->
                    -- TODO: Limit number of friends?
                    (Task.sequence (List.map (\user -> Media.get apiHost token user.id) friends))

                Nothing ->
                    Task.succeed []
    in
        Users.getFriends apiHost token
            |> Task.andThen mapFriends


loadStreams apiHost streams =
    List.map
        (\token ->
            Cmd.batch
                [ (User.getUserSelf apiHost token) |> Task.attempt (mapUserResult token)
                , (loadFeed apiHost token) |> Task.attempt (mapFeedResult token)
                  -- , (Media.getSelf apiHost token) |> Task.attempt (mapMediaResult token)
                ]
        )
        (Dict.keys streams)


updateStream model token update =
    let
        streams =
            Dict.update token update model.streams
    in
        { model | streams = streams }


updateStreamUser : User -> (Maybe Stream -> Maybe Stream)
updateStreamUser user stream =
    case stream of
        Just stream ->
            Just { stream | user = Just user }

        Nothing ->
            Just { emptyStream | user = Just user }


updateStreamRecent : List Media.Media -> (Maybe Stream -> Maybe Stream)
updateStreamRecent media stream =
    case stream of
        Just stream ->
            Just { stream | recent = media }

        Nothing ->
            Just { emptyStream | recent = media }


updateStreamFeed : List (Maybe (List Media.Media)) -> (Maybe Stream -> Maybe Stream)
updateStreamFeed list stream =
    let
        sortedFeed =
            list
                |> List.filterMap identity
                |> List.concat
                |> List.sortWith Media.compareTime
    in
        case stream of
            Just stream ->
                Just { stream | recent = sortedFeed }

            Nothing ->
                Just { emptyStream | recent = sortedFeed }


emptyStream =
    { user = Nothing
    , recent = []
    }


loginButtonLabel streams =
    case Dict.size streams of
        0 ->
            "Login"

        _ ->
            "Add account"


addStream streams =
    div [ class "col-xs-4" ]
        [ div []
            [ div []
                [ div [ class "media", style [ ( "margin", "30px 0" ) ] ]
                    [ a [ class "media-left" ] [ div [ style [ ( "width", "100px" ), ( "height", "100px" ) ], class "bg-faded rounded-circle" ] [] ]
                    , div [ class "media-body align-middle" ]
                        [ a
                            [ class "btn btn-outline-primary"
                            , href "https://api.instagram.com/oauth/authorize/?scope=public_content+follower_list+comments+relationships+likes&client_id=a59977aae66341598cb366c081e0b62d&redirect_uri=http://packfilmapp.com&response_type=token"
                            ]
                            [ text (loginButtonLabel streams) ]
                        ]
                    ]
                ]
            ]
        ]


streamsView data =
    List.map streamView (Dict.values data)


streamView data =
    div [ class "col-xs-4" ]
        [ div []
            [ div []
                [ User.cardView data.user
                  -- TODO: Limit to 250? images
                , div [] (List.map Media.view data.recent)
                ]
            ]
        ]


messageView message =
    div [ class "alert alert-danger" ] [ text message ]


messagesView data =
    List.map messageView data


calculateWidth streams =
    (toString ((Dict.size streams + 1) * 400)) ++ "px"


appView model =
    div [ style [ ( "min-width", calculateWidth model.streams ) ] ]
        [ nav [ class "navbar navbar-full navbar-light bg-faded navbar-static-top" ]
            [ a [ class "navbar-brand" ] [ text "Packfilm" ]
            ]
        , div [ class "container-fluid" ]
            [ div [ class "row" ]
                [ div [ class "col-xs-12" ] (messagesView model.messages)
                ]
            , div [ class "row" ]
                ((streamsView model.streams) ++ [ addStream model.streams ])
            ]
        , nav [ class "navbar navbar-full navbar-light bg-faded" ]
            [ div [ class "col-xs-12" ]
                [ a [ href "http://packfilmapp.com/legal/privacypolicy.html" ] [ text "Privacy Policy" ]
                , text ", "
                , text "Font Awesome by Dave Gandy - http://fontawesome.io"
                ]
            ]
        ]
