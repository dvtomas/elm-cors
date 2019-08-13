module Main exposing (Model, Msg(..), init, initialModel, main, subscriptions, update, view)

import Browser
import Html exposing (..)
import Html.Attributes as A
import Http
import Json.Decode as D
import Json.Encode as E
import String
import Time



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Message =
    { username : String
    , timestamp : Time.Posix
    , topic : String
    , message : String
    }


type alias Discussion =
    List Message


type alias Model =
    { discussion : List Message }


initialModel =
    { discussion = [] }


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel, getMessagesCmd {} )


type Msg
    = MessagesList (Result Http.Error Discussion)


restDbError description httpError =
    { username = ""
    , timestamp = Time.millisToPosix 0
    , topic = description
    , message = httpErrorToString httpError
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MessagesList (Ok messages) ->
            ( { model | discussion = messages }, Cmd.none )

        MessagesList (Err error) ->
            ( { model | discussion = restDbError "Error while retrieving messages list" error :: model.discussion }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    let
        viewMessage message =
            div [ A.class "message" ]
                [ b [] [ text message.username ]
                , text " "
                , i [] [ text (String.fromInt <| Time.posixToMillis <| message.timestamp) ]
                , text " "
                , b [] [ text message.topic ]
                , p [] [ text message.message ]
                ]

        messagesList =
            div [] (List.intersperse (hr [] []) <| List.map viewMessage model.discussion)
    in
    p []
        [ text "I'd like the following to be a list of messages retrieved from RestDb, but actually it's just an CORS error message"
        , br [] []
        , messagesList
        , br [] []
        , text "The following curl expression works and retrieves the messages"
        , br [] []
        , code [] [ text "curl -k -i -H 'Content-Type: application/json' -H 'x-apikey: 5d4edcc758a35b31adeba6a8' -G 'https://fffuuu-c42f.restdb.io/rest/messages'" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- RestDB communication


apiKeyHeader =
    Http.header "x-apikey" "5d4edcc758a35b31adeba6a8"


messageApiUrl =
    "https://fffuuu-c42f.restdb.io/rest/messages"


decoderMessage : D.Decoder Message
decoderMessage =
    D.map4 Message
        (D.field "username" D.string)
        (D.field "timestamp" (D.map Time.millisToPosix D.int))
        (D.field "topic" D.string)
        (D.field "message" D.string)


type alias MessagesQuery =
    {}


encodeMessagesQuery : MessagesQuery -> E.Value
encodeMessagesQuery query =
    E.object []


getMessagesCmd query =
    Http.request
        { method = "GET"
        , headers = [ apiKeyHeader ]
        , url = messageApiUrl
        , body = Http.jsonBody (encodeMessagesQuery query)
        , expect = Http.expectJson MessagesList (D.list decoderMessage)
        , timeout = Nothing
        , tracker = Nothing
        }


httpErrorToString error =
    case error of
        Http.BadUrl string ->
            "Bad URL " ++ string

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus status ->
            "Bad status" ++ String.fromInt status

        Http.BadBody body ->
            "Bad body" ++ body
