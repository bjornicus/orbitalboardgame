port module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { input : String
    , data : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "Loading...", Cmd.none )



-- UPDATE


type Msg
    = Change String
    | Save
    | Suggest String


port updateData : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newWord ->
            ( { model | input = newWord }, Cmd.none )

        Save ->
            ( { model | input = "" }, updateData model.input )

        Suggest newValue ->
            ( { model | data = newValue }, Cmd.none )



-- SUBSCRIPTIONS


port newValue : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    newValue Suggest



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", Html.Attributes.placeholder "new text goes here", value model.input, onInput Change ] []
        , button [ onClick Save ] [ text "Update" ]
        , div [] [ text model.data ]
        ]
