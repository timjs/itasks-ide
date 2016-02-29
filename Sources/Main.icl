module Main

import iTasks
import iTasks.API.Extensions.CodeMirror

import Extensions.Ace

Start world =
    startEngine aceEditor world

codeMirrorHandlers = []
codeMirrorState =
    { configuration = [CMMode "haskell", CMLineNumbers True]
    , position = (0,1)
    , selection = Nothing
    , highlighted = [((0,1),(0,3))]
    , source =
    	[ "definition module iTasks"
		, ""
		, "/**"
		, "* Main iTask module exporting all end user iTask modules"
		, "*/"
		, "import	iTasks.Framework.Engine				// iTasks engine"
		, "    // iTasks API"
		, "    ,   iTasks.API"
		, ""
		, "	//	Miscellaneous machinery"
		, "	,	Text.JSON							// JSON is used for serializing/deserializing strings"
		, "	,	iTasks.Framework.Generic			// Generic foundation modules"
		, "	"
		, "	//	API extensions for user  & workflow management"
		, "	,	iTasks.API.Extensions.Admin.UserAdmin"
		, "	,	iTasks.API.Extensions.Admin.WorkflowAdmin"
		, ""
		, "	//StdEnv modules"
		, "	,	StdInt"
		, "	,	StdBool"
		, "	,	StdString"
		, "	,	StdList"
		, "	,	StdOrdList"
		, "	,	StdTuple"
		, "	,	StdEnum"
		, "	,	StdOverloaded"
		, ""
		, "from StdFunc import id, const, o"
		, "from Data.List import instance Functor []"
        ]
	}

// codeMirrorEditor :: Task CodeMirror
// codeMirrorEditor =
// 	withShared codeMirrorState (\cm ->
//         updateSharedInformation "The code:" [UpdateWith (\cm -> codeMirrorEditlet cm []) (\_ editlet -> editlet.currVal)] cm
//         -||
//         updateSharedInformation "The data:" [] cm)

// codeMirrorEditor :: Task CodeMirror
// codeMirrorEditor =
//     updateInformation "The code:" [UpdateWith (\cm -> codeMirrorEditlet cm []) (\_ editlet -> editlet.currVal)] codeMirrorState

codeMirrorEditor :: Task (Editlet CodeMirror [CodeMirrorDiff] CodeMirrorClient)
codeMirrorEditor =
    updateInformation "The code:" [] (codeMirrorEditlet codeMirrorState codeMirrorHandlers)

aceEditor :: Task (Editlet AceServer AceDiff AceClient)
aceEditor =
    updateInformation "The code:" [] (aceEditlet gDefault{|*|})
