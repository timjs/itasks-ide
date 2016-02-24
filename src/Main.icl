module Main

import iTasks
import iTasks.API.Extensions.Clock

Start world =
    startEngine
        [ publish "/" (WebApp []) (\_ -> viewTime)
        ] world

viewTime :: Task Time
viewTime = viewSharedInformation "The current time is:" [ViewWith AnalogClock] currentTime
