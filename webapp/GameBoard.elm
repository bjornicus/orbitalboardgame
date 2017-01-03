module View exposing (main)

import Svg exposing (..)
import Svg.Attributes exposing (..)


boardDimensions =
    [ x "-800", y "-800", width "1600", height "1600" ]


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


orbitSpace : Int -> Svg msg
orbitSpace spaceNumber =
    let
        orbitNumber =
            spaceToOrbit spaceNumber

        offset =
            spaceOffset spaceNumber
    in
        case orbitNumber of
            0 ->
                circle [ id ("spaceNumber" ++ toString spaceNumber), r "10", fill "#ba4434", transform ("rotate(" ++ toString (offset * 90) ++ ") " ++ translateToOrbit orbitNumber) ] []

            1 ->
                circle [ id ("spaceNumber" ++ toString spaceNumber), r "10", fill "#0e84b7", transform ("rotate(" ++ toString (toFloat offset * 45.0 + 22.5) ++ ") " ++ translateToOrbit orbitNumber) ] []

            2 ->
                circle [ id ("spaceNumber" ++ toString spaceNumber), r "10", fill "#ffc0cb", transform ("rotate(" ++ toString (toFloat offset * 22.5 + (22.5 + 11.25)) ++ ") " ++ translateToOrbit orbitNumber) ] []

            _ ->
                circle [ id ("spaceNumber" ++ toString spaceNumber), r "10", fill "#BBBBEE", transform ("rotate(" ++ toString (toFloat offset * 11.25 + 22.5 + 11.25 + 11.25 / 2) ++ ") " ++ translateToOrbit orbitNumber) ] []


orbitSpaces : List (Svg msg)
orbitSpaces =
    List.map orbitSpace spaces


main =
    svg
        [ version "1.1"
        , viewBox "-800 -800 1600 1600"
        ]
        (background :: sun :: orbitSpaces)
