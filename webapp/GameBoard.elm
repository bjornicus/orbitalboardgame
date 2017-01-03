module View exposing (main)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Html exposing (Html, program)
import Time exposing (Time, second)


boardDimensions =
    [ x "-800", y "-800", width "1600", height "1600" ]


boardRadius : Int
boardRadius =
    800


lineWidth : Float
lineWidth =
    1600 / 800



-- todo sun and background gradients:     spaceGradient=ctx.createRadialGradient(center,center,0.2*radius,center,center,0.6*radius),
--sunGradient=ctx.createRadialGradient(center,center,0.08*radius,center,center,0.1*radius);
--sunGradient.addColorStop(0,"#FFFF33");
--sunGradient.addColorStop(1,"#001c39");
--spaceGradient.addColorStop(0,"#001c39");
--spaceGradient.addColorStop(1, "#000912");


sun =
    circle [ r "50", fill "#ffff33" ] []


background =
    rect (boardDimensions ++ [ rx "15", ry "15" ]) []


spaces =
    List.range 0 59


orbitDistance orbitNumber =
    if orbitNumber <= 0 then
        (800 / 4.25)
    else
        (orbitDistance (orbitNumber - 1)) * 1.578


translateToOrbit orbitNumber =
    "translate(" ++ toString (orbitDistance orbitNumber) ++ ")"


spaceToOrbit spaceNumber =
    if spaceNumber < 4 then
        0
    else if spaceNumber < 12 then
        1
    else if spaceNumber < 28 then
        2
    else
        3


spaceOffset spaceNumber =
    if spaceNumber < 4 then
        spaceNumber
    else if spaceNumber < 12 then
        spaceNumber - 4
    else if spaceNumber < 28 then
        spaceNumber - 12
    else
        spaceNumber - 28


transformForSpace spaceNumber =
    let
        orbitNumber =
            spaceToOrbit spaceNumber

        offset =
            spaceOffset spaceNumber
    in
        case orbitNumber of
            0 ->
                transform ("rotate(" ++ toString (offset * -90) ++ ") " ++ translateToOrbit orbitNumber)

            1 ->
                transform ("rotate(" ++ toString (toFloat offset * -45.0 - 22.5) ++ ") " ++ translateToOrbit orbitNumber)

            2 ->
                transform ("rotate(" ++ toString (toFloat offset * -22.5 - (22.5 + 11.25)) ++ ") " ++ translateToOrbit orbitNumber)

            _ ->
                transform ("rotate(" ++ toString (toFloat offset * -11.25 - 22.5 - 11.25 - 11.25 / 2) ++ ") " ++ translateToOrbit orbitNumber)


colorForOrbit orbitNumber =
    case orbitNumber of
        0 ->
            "#ba4434"

        1 ->
            "#0e84b7"

        2 ->
            "#ffc0cb"

        _ ->
            "#BBBBEE"


orbitSpace : Int -> Svg msg
orbitSpace spaceNumber =
    let
        orbitNumber =
            spaceToOrbit spaceNumber
    in
        circle
            [ id <| "spaceNumber" ++ toString spaceNumber
            , r "10"
            , fill <| colorForOrbit orbitNumber
            , transformForSpace spaceNumber
            ]
            []


orbitSpaces : List (Svg msg)
orbitSpaces =
    List.map orbitSpace spaces


boostPath fromSpace toSpace =
    let
        fromOrbitNumber =
            spaceToOrbit fromSpace

        toOrbitNumber =
            spaceToOrbit toSpace

        fromSpaceOffset =
            spaceOffset fromSpace

        toSpaceOffset =
            spaceOffset toSpace

        --let xctrl = targetRadius*Math.cos(targetRotationAngle/2);
        --let yctrl = -targetRadius*Math.sin(targetRotationAngle/2);
        --let xnext = targetRadius*Math.cos(targetRotationAngle);
        --let ynext = -targetRadius*Math.sin(targetRotationAngle);
    in
        Svg.path [ transform (translateToOrbit fromOrbitNumber), d "M0,0 q100,100,300,0", strokeWidth (toString lineWidth), stroke "#FFFFFF" ] []


highlightSpace spaceNumber =
    circle
        [ r "20"
        , stroke "#AAAAAA"
        , transformForSpace spaceNumber
        ]
        []


view model =
    svg
        [ version "1.1"
        , viewBox "-800 -800 1600 1600"
        ]
        (background :: sun :: boostPath 0 4 :: List.append (List.map highlightSpace model.orbiters) orbitSpaces)


main =
    program { init = init, view = view, update = update, subscriptions = subs }



-- UPDATE


type Msg
    = Orbit Time
    | Ahead
    | Behind
    | Higher
    | Lower


type alias Model =
    { orbiters : List Int
    }


orbit : Int -> Int
orbit spaceNumber =
    if spaceNumber < 4 then
        (spaceNumber + 1) % 4
    else if spaceNumber < 12 then
        ((spaceOffset spaceNumber + 1) % 8) + 4
    else if spaceNumber < 28 then
        ((spaceOffset spaceNumber + 1) % 16) + 12
    else
        ((spaceOffset spaceNumber + 1) % 32) + 28


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Orbit t ->
            ( { orbiters = List.map orbit model.orbiters }, Cmd.none )

        Ahead ->
            ( model, Cmd.none )

        Behind ->
            ( model, Cmd.none )

        Higher ->
            ( model, Cmd.none )

        Lower ->
            ( model, Cmd.none )


init : ( Model, Cmd Msg )
init =
    ( Model [ 0, 4, 12, 28 ], Cmd.none )


subs : Model -> Sub Msg
subs model =
    Time.every 500 Orbit
