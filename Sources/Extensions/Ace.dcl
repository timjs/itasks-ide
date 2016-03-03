definition module Extensions.Ace

/// This module is to be used qualified!!!
///
///     import Extensions.Ace as Ace
///     Ace.editlet ...

import iTasks.API.Core.Client.Editlet

:: AceEditor = AceEditor //TODO

:: AceClient =
    { editor :: !JSObj AceEditor
    }
:: AceServer =
    { configuration :: [AceOption]
    , position :: Position //FIXME multiple cursors?
    , selection :: Maybe Region
    , highlights :: [Region]
    , source :: [String] //FIXME
    }
:: AceDiff = AceDiff //TODO

:: AceOption = AceOption //TODO

derive class iTask AceEditor, AceClient, AceServer, AceDiff, AceOption

:: Position :== (Line, Column)
:: Region :== (Position, Position)
:: Line :== Int
:: Column :== Int


aceEditlet :: AceServer -> Editlet AceServer AceDiff AceClient
