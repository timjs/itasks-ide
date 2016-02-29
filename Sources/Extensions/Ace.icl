implementation module Extensions.Ace

??? = ???
($) infixr 9 // :: (a -> b) a -> b
($) f a :== f a

import iTasks
import iTasks.API.Core.Client.Editlet
import _SystemArray

derive class iTask AceEditor, AceClient, AceServer, AceDiff, AceOption

:: AceHandler :==
    ComponentId {JSObj JSEvent} AceClient !*JSWorld
    -> *(!AceClient, !ComponentDiff AceDiff AceClient, !*JSWorld)

:: AceHandleMaker :== AceHandler ComponentId -> JSFun ()

// instance Editlet AceServer AceDiff AceClient where
//     onInit
//     onDiffClient
//     onDiffServer
//     generateDiff
//     generateUI

aceEditlet :: AceServer -> Editlet AceServer AceDiff AceClient
aceEditlet editor =
    { Editlet
    | currVal = editor
    , defValSrv = gDefault{|*|} // or `neutral`
    , genUI = editorUI
    , initClient = onInit
    , appDiffClt = onDiffClient
    , appDiffSrv = onDiffServer
    , genDiffSrv = generateAceDiff
    }
where
    editorUI id world = (
        { ComponentHTML
        | html = DivTag [IdAttr ("editor-" +++ toString id), StyleAttr "width:100%; height:100%"] []
        , width = ExactSize 600
        , height = ExactSize 600
        }, world)

initClient ::
    AceHandleMaker ComponentId {JSObj JSEvent} AceClient !*JSWorld
    -> *(AceClient, ComponentDiff AceDiff AceClient, !*JSWorld)
initClient handleMaker id eventHandlers aceClient world
    // # (aceEditor, world) = getObject (getElementById $ "editor-" +++ toString id) world
    /* var ace = this.ace; */
    # (ace, world) = findObject "ace" world
    /* var editor = ace.edit("editor"); */
    # (aceEditor, world) = (ace .# "edit" .$ ("editor-") +++ toString id) world
    /* editor.setTheme("ace/theme/twilight"); */
    # (_, world) = (aceEditor .# "setTheme" .$ ("ace/theme/solarized_dark")) world
    /* editor.session.setMode("ace/mode/javascript"); */
    # (_, world) = (aceEditor .# "session" .# "setMode" .$ ("ace/mode/haskell")) world
    = (aceClient, NoDiff, world)

// // We get an AceHanldeMaker, which is a backdoor to create JavaScript event
// // handlers tailored to this Ace instance.
// onInit :: AceHandleMaker ComponentId -> JSIO AceClient
// onInit handleMaker id world =
//     let clientState = gDefault{|*|} in
//     findObject "ace" >>= \aceObject ->
//     if (jsIsUndefined aceObject) (
//         // The script is loaded asynchroniously, thus we have to wrap our
//         // initialization function in a handler which JavaScript calls on a
//         // successfull load.
//         addJSFromUrl "src-min-noconflict/ace.js"
//             (Just $ handleMaker (initClient handleMaker) id) >>>
//         pure clientState
//     ) (
//         initClient handleMaker id clientState >>= \(clientState, _) >>>
//         pure clientState
//     )

// We get an AceHandleMaker, which is a backdoor to create JavaScript event
// handlers tailored to this Ace instance.
onInit :: AceHandleMaker ComponentId !*JSWorld -> *(AceClient, !*JSWorld)
onInit handleMaker id world
    # clientState = gDefault{|*|}
    # (ace, world) = findObject "ace" world
    | jsIsUndefined ace
        // The script is loaded asynchroniously, thus we have to wrap our
        // initialization function in a handler which JavaScript calls on a
        // successfull load.
        # world = addJSFromUrl "ace/src-min-noconflict/ace.js"
            (Just $ handleMaker (initClient handleMaker) id) world
        = (clientState, world)
    # (clientState, _, world) = initClient handleMaker id {} clientState world
    = (clientState, world)

onDiffClient :: ((EditletEventHandlerFunc AceDiff AceClient) ComponentId -> JSFun ()) ComponentId AceDiff AceClient *JSWorld -> *(AceClient, *JSWorld)
onDiffClient handler id diff client world = (client, world)

onDiffServer :: AceDiff AceServer -> AceServer
onDiffServer diff server = server

generateAceDiff :: AceServer AceServer -> Maybe AceDiff
generateAceDiff old new = Nothing
