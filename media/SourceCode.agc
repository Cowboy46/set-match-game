// SetMatch
// Produced by John Daudelin
// BottleAppGames 2013

SetVirtualResolution( 320, 480 )
SetSyncRate( 60, 0 )

Print ( "Loading" )
sync()

global name1$
global name2$
global audio = 1
global rank$
global rank2$
global music = 0
global sound = 0

OpenToRead (1,"Remembered.txt")
name1$ = ReadString( 1 )
CloseFile( 1 )

Connection = CreateHTTPConnection ()
Connected  = SetHTTPHost( Connection, "www.treksoftware.org", 0 )

While GetHTTPResponseReady(Connection) = 0
    Print("Loading...")
EndWhile

rank$ = SendHTTPRequest( Connection, "BottleAppGames/getRating.php","Name="+name1$ )

if rank$ = ""
    OpenToRead( 1, "Rank.txt" )
    rank$ = ReadString( 1 )
    if rank$ = ""
        rank$ = "1000"
        OpenToWrite( 1, "Rank.txt" )
        WriteString( 1, "1000" )
        CloseFile( 1 )
    endif
    CloseFile( 1 )
endif

Menu()

function Menu()

    BackGround = CreateSprite( LoadImage( "Background6.png" ) )

    LoadImage( 1, "SignIn.png" )
    LoadImage( 2, "DisplayPanel.png" )
    LoadImage( 3, "SignUp.png" )
    LoadImage( 4, "SignOut.png" )
    LoadImage( 5, "Settings.png" )
    LoadImage( 6, "HelpButton.png" )
    LoadImage( 7, "Play3.png" )
    LoadImage( 8, "Play1.png" )
    LoadImage( 9, "Play2.png" )
    LoadImage( 10, "AccountButton.png" )
    LoadImage( 11, "company.png" )
    LoadImage( 12, "SoundActive.png" )
    LoadImage( 13, "SoundMuted.png" )
    LoadImage( 14, "Logo3.png" )
    LoadImage( 20, "Play32.png" )
    LoadImage( 21, "Play12.png" )
    LoadImage( 22, "ViewCurrent.png" )
    LoadImage( 23, "ViewCurrent2.png" )
    LoadSound( 1, "Swoosh.wav" )
    LoadSound( 2, "Ding.wav" )
    LoadSound( 3, "Select.wav" )

    if name1$ = "" or name1$ = "-1"
        CreateSprite( 1, 1 )
        SetSpriteScale( 1, .8, .8 )
        SetSpriteOffset( 1, 80, 0 )
        SetSpritePositionByOffset( 1, 317, 5 )

        CreateSprite( 3, 3 )
        SetSpriteScale( 3, .8, .8 )
        SetSpritePosition( 3, 3, 5 )
    else
        CreateSprite( 1, 4 )
        SetSpriteScale( 1, .8, .8 )
        SetSpriteOffset( 1, 80, 0 )
        SetSpritePositionByOffset( 1, 317, 5 )

        CreateText( 3, name1$ + " (" + rank$ + ")" )
        SetTextPosition( 3, 5, 8 )
        SetTextSize( 3, 20 )
    endif

    if GetMusicExists( 1 ) = 0
        LoadMusic( 1, "MenuSoundtrack.mp3" )
        PlayMusic( 1 )
    elseif GetMusicExists( 1 ) = 1 and GetMusicPlaying() = 0
        PlayMusic( 1 )
    endif

    CreateSprite( 5, 5 )
    SetSpriteScale( 5, .5, .5 )
    SetSpritePosition( 5, 0, 430)

    CreateText( 5, "Settings" )
    SetTextSize( 5, 24 )
    SetTextPosition( 5, 50, 444 )

    CreateSprite( 6, 6 )
    SetSpriteScale( 6, .4, .4 )
    SetSpritePosition( 6, 5, 385 )

    CreateSprite( 8, 8 )
    SetSpritePosition( 8, 60, 195 )
    if name1$ = "" or name1$ = "-1"
        SetSpriteImage( 8, 21 )
        SetSpriteColorAlpha( 8, 200 )
    endif

    CreateSprite( 9, 9 )
    SetSpritePosition( 9, 75, 135 )

    CreateSprite( 10, 11 )
    SetSpriteScale( 10, .8, .8 )
    SetSpritePosition( 10, 215, 440 )

    CreateSprite( 11, 14 )
    SetSpritePosition( 11, 70, 47 )

    CreateSprite( 12, 22 )
    SetSpritePosition( 12, 40, 255 )
    if name1$ = "" or name1$ = "-1"
        SetSpriteImage( 12, 23 )
        SetSpriteColorAlpha( 12, 200 )
    endif

    CreateText( 6, "Help" )
    SetTextSize( 6, 24 )
    SetTextPosition( 6, 50, 394 )

    do
        sync()

        if GetPointerPressed() = 1
            If GetSpriteHitTest( 1, GetPointerX(), GetPointerY() ) = 1
                if name1$ = "" or name1$ = "-1"
                    Delete()
                    Login()
                else
                    name1$ = ""
                    OpenToWrite( 1,"Remembered.txt" )
                    WriteString( 1, name1$ )
                    CloseFile( 1 )

                    Delete()
                    sync()
                    Menu()
                endif
            endif
            if GetSpriteExists( 3 ) = 1
                if GetSpriteHitTest( 3, GetPointerX(), GetPointerY() ) = 1
                    Delete()
                    SignUp()
                endif
            endif
            if GetSpriteHitTest( 9, GetPointerX(), GetPointerY() ) = 1
                PlaySound( 2 )
                Delete()
                Game( 3 )
            endif

            // new game

            if GetSpriteHitTest( 8, GetPointerX(), GetPointerY() ) = 1 and GetSpriteColorAlpha( 8 ) = 255

                Connection = CreateHTTPConnection ()
                Connected  = SetHTTPHost( Connection, "www.treksoftware.org", 0 )

                While GetHTTPResponseReady(Connection) = 0
                    Print("Loading...")
                EndWhile

                name2$ = SendHTTPRequest( Connection, "BottleAppGames/findGame.php","Name=" + name1$)
                if name2$ = "-1"
                    player1id$ = SendHTTPRequest( Connection, "BottleAppGames/getId.php","Name=" + name1$)
                    SendHTTPRequest( Connection, "BottleAppGames/AddGame.php","Player1=" + player1id$)
                else
                    name2$ = SendHTTPRequest( Connection, "BottleAppGames/getName.php","Player=" + name2$)
                    rank2$ = SendHTTPRequest( Connection, "BottleAppGames/getRating.php","Name=" + name2$)
                    Delete()
                    NewGameScreen()
                endif
            endif
            // end new game

            // settings
            if GetSpriteHitTest( 5, GetPointerX(), GetPointerY() ) = 1 or GetTextHitTest( 5, GetPointerX(), GetPointerY() ) = 1
                PlaySound( 1 )
                LoadImage( 100, "MusicOn.png" )
                LoadImage( 101, "SoundOn.png" )
                LoadImage( 102, "MusicOff.png" )
                LoadImage( 103, "SoundOff.png" )
                LoadImage( 104, "SettingsLogo.png" )

                CreateSprite( 100, 100 )
                if music = 1
                    SetSpriteImage( 100, 102 )
                endif
                SetSpriteScale( 100, .9, .9 )
                SetSpritePosition( 100, 395, 100 )

                CreateSprite( 101, 101 )
                if sound = 1
                    SetSpriteImage( 101, 103 )
                endif
                SetSpriteScale( 101, .9, .9 )
                SetSpritePosition( 101, 395, 170 )

                CreateSprite( 104, 104 )
                SetSpriteScale( 104, .7, .7 )
                SetSpritePosition( 104, 400, 10 )

                while GetSpriteX( 5 ) > -320
                    for object = 1 to 150
                        if GetSpriteExists( object )=1
                            if GetSpriteImageId( object ) <> 11
                                SetSpriteX( object, GetSpriteX( object )-20 )
                            endif
                        endif
                        if GetTextExists( object )=1
                            SetTextX( object, GetTextX( object ) - 20 )
                        endif
                    next object
                    sync()
                endwhile

                CreateSprite( 102, LoadImage( "Left.png" ) )
                SetSpriteScale( 102, .7, .7 )
                SetSpritePosition( 102, 4, 430 )

                do
                    sync()
                    if GetPointerPressed()=1
                        If GetSpritehitTest( 102, GetpointerX(), GetPointerY() )=1
                            PlaySound( 1 )
                            DeleteSprite( 102 )
                            while GetSpriteX( 5 ) < 0
                                for object = 1 to 150
                                    if GetSpriteExists( object )=1
                                        if GetSpriteImageId( object ) <> 11
                                            SetSpriteX( object, GetSpriteX( object )+20 )
                                        endif
                                    endif
                                    if GetTextExists( object )=1
                                        SetTextX( object, GetTextX( object ) + 20 )
                                    endif
                                next object
                                sync()
                            endwhile
                            for x = 100 to 150
                                if GetSpriteExists( x ) = 1 then DeleteSprite( x )
                                if GetImageExists( x ) = 1 then DeleteImage( x )
                            next x
                            exit
                        endif
                        if GetSpriteHitTest( 100, GetPointerX(), GetPointery() )=1
                            if GetSpriteImageId( 100 )=100
                                SetSpriteImage( 100, 102 )
                                SetMusicSystemVolume (0)
                                music = 1
                            else
                                SetSpriteImage( 100, 100 )
                                SetMusicSystemVolume (100)
                                music = 0
                            endif
                        endif
                        if GetSpriteHitTest( 101, GetPointerX(), GetPointery() )=1
                            if GetSpriteImageId( 101 )=101
                                SetSpriteImage( 101, 103 )
                                SetSoundSystemVolume (0)
                                sound = 1
                            else
                                SetSpriteImage( 101, 101 )
                                SetSoundSystemVolume (100)
                                sound = 0
                            endif
                        endif
                    endif
                loop
            endif
            // end settings

            // view current games
            if GetSpriteHitTest( 12, GetPointerX(), GetPointerY() ) = 1 and GetSpriteColorAlpha( 12 ) = 255
                LoadImage( 100, "MyGames.png" )
                LoadImage( 101, "Home.png" )
                LoadImage( 102, "GameBanner.png" )

                CreateSprite( 100, 100 )
                SetSpritePosition( 100, 379, 20 )

                PlaySound( 1 )

                while GetSpriteX( 5 ) > -320
                    for object = 1 to 150
                        if GetSpriteExists( object )=1
                            if GetSpriteImageId( object ) <> 11
                                SetSpriteX( object, GetSpriteX( object ) - 20 )
                            endif
                        endif
                        if GetTextExists( object )=1
                            SetTextX( object, GetTextX( object ) - 20 )
                        endif
                    next object
                    sync()
                endwhile

                CreateSprite( 101, 101 )
                SetSpriteScale( 101, .4, .4 )
                SetSpritePosition( 101, 2, 439)

                sync()

                Connection = CreateHTTPConnection ()
                Connected  = SetHTTPHost( Connection, "www.treksoftware.org", 0 )

                While GetHTTPResponseReady(Connection) = 0
                    Print("Loading...")
                EndWhile

                number$ = SendHTTPRequest( Connection, "BottleAppGames/getTotalGames.php","Name=" + name1$)
                nameId$ = SendHTTPRequest( Connection, "BottleAppGames/getId.php","Name=" + name1$)

                if number$="0"
                    CreateText( 100, "You have no games going right now.")
                    SetTextAlignment( 100, 1 )
                    SetTextPosition( 100, 160, 150 )
                    SetTextSize( 100, 14 )

                    CreateSprite( 99, 8 )
                    SetSpritePosition( 99, 60, 200 )
                else
                    number = val ( number$ )
                    y = 80
                    spriteId = 101
                    for i = 1 to number
                        spriteId = spriteId + 1
                        CreateSprite( spriteId, 102 )
                        SetSpritePosition( spriteId, 5, y )
                        SetSpriteColorAlpha( spriteId, 0)

                        while GetSpriteColorAlpha( spriteId ) < 255
                            SetSpriteColorAlpha( spriteId, GetSpriteColorAlpha( spriteId ) + 15 )
                            sync()
                        endwhile

                        name2$ = SendHTTPRequest( Connection, "BottleAppGames/getOtherPlayer.php","Number=" + STR(i)+"&Id=" + nameId$)
                        name2$ = SendHTTPRequest( Connection, "BottleAppGames/getName.php","Player=" + name2$ )
                        turn$ = SendHTTPRequest( Connection, "BottleAppGames/getTurn.php","Number=" + STR(i)+"&Id=" + nameId$)

                        CreateText( 100 + i, name1$ + " vs. " + name2$ )
                        SetTextPosition( 100 + i, 20, y + 15 )
                        SetTextSize( 100 + i, 14 )
                        SetTextColor( 100 + i, 0, 0, 0, 255 )

                        spriteId = spriteId + 1
                        CreateSprite( spriteId, LoadImage( "Turn" + turn$ + ".png" ) )
                        SetSpritePosition( spriteId, 245, y + 3 )
                        SetSpriteScale( spriteId, .8, .8 )

                        PlaySound( 3 )

                        y = y + 55
                    next i
                endif


                do
                    sync()
                    if GetPointerPressed()=1 and GetSpriteHitTest( 101, GetPointerX(), GetPointerY() )=1
                        DeleteSprite( 101 )
                        PlaySound( 1 )
                        while GetSpriteX( 5 ) < 0
                            for object = 1 to 5000
                                if GetSpriteExists( object )=1
                                    if GetSpriteImageId( object ) <> 11
                                        SetSpriteX( object, GetSpriteX( object )+20 )
                                    endif
                                endif
                                if GetTextExists( object )=1
                                    SetTextX( object, GetTextX( object ) + 20 )
                                endif
                            next object
                            sync()
                        endwhile
                        for object = 99 to 5000
                            DeleteSprite( object )
                            DeleteText( object )
                            DeleteImage( object )
                        next object
                        exit
                    endif
                    if GetPointerPressed()=1 and GetSpriteExists( 99 ) = 1
                        If GetSpriteHitTest( 99, GetPointerX(), GetPointerY() )=1
                            Delete()

                            name2$ = SendHTTPRequest( Connection, "BottleAppGames/findGame.php","Name=" + name1$)
                            if name2$ = "-1"
                                player1id$ = SendHTTPRequest( Connection, "BottleAppGames/getId.php","Name=" + name1$)
                                SendHTTPRequest( Connection, "BottleAppGames/AddGame.php","Player1=" + player1id$)
                                Delete()
                                Game( 0 )
                            else
                                name2$ = SendHTTPRequest( Connection, "BottleAppGames/getName.php","Player=" + name2$)
                                rank2$ = SendHTTPRequest( Connection, "BottleAppGames/getRating.php","Name=" + name2$)
                                Delete()
                                NewGameScreen()
                            endif
                        endif
                    endif
                loop
            endif
        endif
    loop

endfunction

function NewGameScreen()
    Background = CreateSprite( LoadImage( "Background5.png" ) )
    LoadImage( 1, "YourTurn.png" )
    LoadImage( 2, "Round1Black.png" )
    LoadImage( 3, "Start.png" )
    LoadImage( 4, "Home.png" )

    CreateText( 1, name1$ + " (" + rank$ + ")")
    SetTextAlignment( 1, 1 )
    SetTextPosition( 1, 160, 130 )
    SetTextSize( 1, 24 )

    CreateText( 2, "vs." )
    SetTextAlignment( 2, 1 )
    SetTextPosition( 2, 160, 180 )
    SetTextSize( 2, 22 )

    CreateText( 3, name2$ + " (" + rank2$ + ")")
    SetTextAlignment( 3, 1 )
    SetTextPosition( 3, 160, 230 )
    SetTextSize( 3, 24 )

    CreateSprite( 1, 1 )
    SetSpriteScale( 1, .7, .7 )
    SetSpritePosition( 1, 100, 340 )

    CreateSprite( 2, 2 )
    SetSpritePosition( 2, 85, 20 )

    CreateSprite( 3, 3 )
    SetSpritePosition( 3, 110, 390 )

    CreateSprite( 4, 4 )
    SetSpriteScale( 4, .4, .4 )
    SetSpritePosition( 4, 2, 439 )

    do
        sync()
        If GetPointerPressed()=1 and GetSpriteHitTest( 3, GetPointerX(), GetPointerY() )=1
            Delete()
            Game( 0 )
        endif
        If GetPointerPressed()=1 and GetSpriteHitTest( 4, GetPointerX(), GetPointerY() )=1
            Delete()
            Menu()
        endif
    loop
endfunction

function Login()

Background = (CreateSprite(LoadImage("Background5.png")))
LoadImage( 2, "Login.png" )
LoadImage( 3, "Arrow.png" )
LoadImage( 4, "SignUp.png" )
LoadImage( 5, "Question.png" )
LoadImage( 6, "EmptyCheckBox.png" )
LoadImage( 7, "FilledCheckBox.png" )
LoadImage( 8, "Home.png" )

CreateSprite( 2, 2 )
SetSpritePosition( 2, 10, 20 )

CreateSprite( 3, 3 )
SetSpritePosition( 3, 230, 230 )
SetSpriteScale( 3, .8, .8 )

CreateSprite( 4, 4 )
SetSpritePosition( 4, 110, 440 )

CreateSprite( 5, 5 )
SetSpritePosition( 5, 62, 415 )
SetSpriteScale( 5, .8, .8 )

CreateSprite( 6, 6 )
SetSpritePosition( 6, 10, 225 )
SetSpriteScale( 6, .5, .5 )

CreateSprite( 7, 8 )
SetSpriteScale( 7, .4, .4 )
SetSpritePosition( 7, 2, 439 )

CreateText( 6, "Remember me")
SetTextPosition( 6, 30, 230 )
SetTextSize( 6, 15 )

CreateText( 1, "Email" )
SetTextPosition( 1, 10, 128 )
SetTextSize( 1, 22 )

CreateText( 2, "Password" )
SetTextPosition( 2, 10, 178 )
SetTextSize( 2, 22 )

CreateEditBox( 1 )
SetEditBoxPosition( 1, 130, 126 )
SetEditBoxSize( 1, 180, 27 )
SetEditBoxTextSize( 1, 22 )

CreateEditBox( 2 )
SetEditBoxPosition( 2, 130, 176 )
SetEditBoxSize( 2, 180, 27 )
SetEditBoxTextSize( 2, 22 )

Connection = CreateHTTPConnection ()
Connected  = SetHTTPHost( Connection, "www.treksoftware.org", 0 )

While GetHTTPResponseReady(Connection) = 0
   Print("Waiting for response...")
EndWhile

do
    sync()
    if GetPointerPressed()=1
        if GetSpriteHitTest( 3, GetPointerX(), GetPointerY() ) = 1
            email$ = GetEditBoxText( 1 )
            password$ = GetEditBoxText( 2 )
            name1$ = SendHTTPRequest( Connection, "BottleAppGames/Login.php","Email="+email$+"&Password="+password$ )
            if name1$ = "-1"
                if GetTextExists( 3 )=1
                    DeleteText( 3 )
                endif

                sync()

                CreateText( 3, "Invalid email and password.")
                SetTextSize( 3, 15)
                SetTextAlignment( 3, 1 )
                SetTextPosition( 3, 160, 210 )
                SetTextColor( 3, 255, 0, 0, 255 )
            else
                if GetSpriteimageId( 6 ) = 7
                    OpenToWrite (1,"Remembered.txt",0)
                    WriteString ( 1, name1$ )
                    CloseFile (1)
                else
                    OpenToWrite (1,"Remembered.txt",0)
                    WriteString( 1, "" )
                    CloseFile (1)
                endif
                Delete()
                Menu()
            endif
        endif
        if GetSpriteHitTest( 4, GetPointerX(), GetPointerY() ) = 1
            Delete()
            SignUp()
        endif
        if GetSpriteHitTest( 6, GetPointerX(), GetPointerY() ) = 1
            if GetSpriteImageId( 6 )=6
                SetSpriteImage( 6, 7 )
            else
                SetSpriteImage( 6, 6 )
            endif
        endif
        if GetSpriteHitTest( 7, GetPointerX(), GetPointerY() ) = 1
            Delete()
            Menu()
        endif
    endif
loop

endfunction

function SignUp()

Background = (CreateSprite(LoadImage("Background5.png")))

LoadImage( 1, "Info.png" )
LoadImage( 2, "SignUpText.png" )
LoadImage( 3, "SignUp.png" )
LoadImage( 6, "EmptyCheckBox.png" )
LoadImage( 7, "FilledCheckBox.png" )
LoadImage( 8, "Home.png" )

CreateSprite( 1, 1 )
SetSpritePosition( 1, 10, 10 )

CreateSprite( 2, 2 )
SetSpritePosition( 2, 10, 120 )

CreateSprite( 3, 3 )
SetSpritePosition( 3, 230, 380 )
SetSpriteScale( 3, .8, .8 )

CreateSprite( 6, 6 )
SetSpritePosition( 6, 10, 340 )
SetSpriteScale( 6, .5, .5 )

CreateSprite( 7, 8 )
SetSpriteScale( 7, .4, .4 )
SetSpritePosition( 7, 2, 439 )

CreateText( 1, "Username" )
SetTextPosition( 1, 10, 178 )
SetTextSize( 1, 22 )

CreateText( 2, "Email" )
SetTextPosition( 2, 10, 238 )
SetTextSize( 2, 22 )

CreateText( 3, "Password" )
SetTextPosition( 3, 10, 298 )
SetTextSize( 3, 22 )

CreateText( 6, "Remember me")
SetTextPosition( 6, 30, 345 )
SetTextSize( 6, 15 )

CreateEditBox( 1 )
SetEditBoxPosition( 1, 130, 176 )
SetEditBoxSize( 1, 180, 27 )
SetEditBoxTextSize( 1, 22 )

CreateEditBox( 2 )
SetEditBoxPosition( 2, 100, 236 )
SetEditBoxSize( 2, 210, 27 )
SetEditBoxTextSize( 2, 22 )

CreateEditBox( 3 )
SetEditBoxPosition( 3, 130, 296 )
SetEditBoxSize( 3, 180, 27 )
SetEditBoxTextSize( 3, 22 )

Connection = CreateHTTPConnection ( )
Connected  = SetHTTPHost( Connection, "www.treksoftware.org", 0 )

While GetHTTPResponseReady(Connection) = 0
    Print("Waiting for response...")
EndWhile

do
    sync()
    if GetPointerPressed()=1
        if GetSpriteHitTest( 3, GetPointerX(), GetPointerY() ) = 1
        If GetTextExists( 5 )=1
            deleteText( 5 )
        endif
        If GetTextExists( 4 )=1
            deleteText( 4 )
        endif
        If GetTextExists( 7 ) = 1
            deleteText( 7 )
        endif

        sync()

        for i = 1 to 3

            if GetEditBoxText( i ) = ""


                sync()

                if i = 1
                    CreateText( 4, "You must have a username." )
                    SetTextSize( 4, 14 )
                    SetTextAlignment( 4, 1 )
                    SetTextPosition( 4, 160, 205 )
                    SetTextColor( 4, 255, 0, 0, 255 )
                endif
                if i = 2
                    CreateText( 5, "You must have an email." )
                    SetTextSize( 5, 14 )
                    SetTextAlignment( 5, 1 )
                    SetTextPosition( 5, 160, 265 )
                    SetTextColor( 5, 255, 0, 0, 255 )
                endif
                if i = 3
                    CreateText( 7, "You must have a password." )
                    SetTextSize( 7, 14 )
                    SetTextAlignment( 7, 1 )
                    SetTextPosition( 7, 160, 325 )
                    SetTextColor( 7, 255, 0, 0, 255 )
                endif

                counter = counter + 1
            endif
        next i

        if counter = 0
            name1$ = GetEditBoxText( 1 )
            email$ = GetEditBoxText( 2 )
            password$ = GetEditBoxText( 3 )

            g_Net_Connection = CreateHTTPConnection ( )
            g_Net_Connected  = SetHTTPHost( g_Net_Connection, "www.treksoftware.org", 0 )

            While GetHTTPResponseReady(g_Net_Connection) = 0
                Print("Waiting for response...")
            EndWhile

            response$ = SendHTTPRequest( g_Net_Connection, "BottleAppGames/register.php", "Name="+name1$+"&Email="+email$+"&Password="+password$ )

            if response$ = "-1"
                If GetTextExists( 4 )=1
                    deleteText( 4 )
                endif

                CreateText( 4, "An account has already been registered" )
                SetTextSize( 4, 12 )
                SetTextAlignment( 4, 1 )
                SetTextPosition( 4, 160, 265 )
                SetTextColor( 4, 255, 0, 0, 255 )

                CreateText( 5, " for that email. Please try again." )
                SetTextSize( 5, 13 )
                SetTextAlignment( 5, 1 )
                SetTextPosition( 5, 160, 276 )
                SetTextColor( 5, 255, 0, 0, 255 )

            elseif response$ = "-2"
                If GetTextExists( 4 )=1
                    deleteText( 4 )
                endif

                CreateText( 4, "An account has already been registered" )
                SetTextSize( 4, 12 )
                SetTextAlignment( 4, 1 )
                SetTextPosition( 4, 160, 205 )
                SetTextColor( 4, 255, 0, 0, 255 )

                CreateText( 5, " for that username. Please try again." )
                SetTextSize( 5, 13 )
                SetTextAlignment( 5, 1 )
                SetTextPosition( 5, 160, 216 )
                SetTextColor( 5, 255, 0, 0, 255 )

            elseif response$ = "-3"
                If GetTextExists( 4 )=1
                    deleteText( 4 )
                endif

                CreateText( 4, "Username must be less than 10 characters." )
                SetTextSize( 4, 12 )
                SetTextAlignment( 4, 1 )
                SetTextPosition( 4, 160, 205 )
                SetTextColor( 4, 255, 0, 0, 255 )

            else
                if GetSpriteimageId( 6 ) = 7
                    OpenToWrite (1,"Remembered.txt",0)
                    WriteString ( 1, name1$ )
                    CloseFile (1)
                else
                    OpenToWrite (1,"Remembered.txt",0)
                    WriteString( 1, "" )
                    CloseFile (1)
                endif
                Delete()
                Menu()
            endif
        endif
        endif

        if GetSpriteHitTest( 6, GetPointerX(), GetPointerY() ) = 1
            if GetSpriteImageId( 6 )=6
                SetSpriteImage( 6, 7 )
            else
                SetSpriteImage( 6, 6 )
            endif
        endif

        if GetSpriteHitTest( 7, GetPointerX(), GetPointerY() ) = 1
            Delete()
            Menu()
        endif
    endif

    counter = 0
loop

endfunction

function Delete()
    for i = 1 to 3000
        If GetSpriteExists( i ) then DeleteSprite( i )
        If GetSoundExists( i ) then DeleteSound( i )
        If GetImageExists( i ) then DeleteImage( i )
        if GetTextExists( i ) then DeleteText( i )
        if GetEditBoxExists( i ) then DeleteEditBox( i )
    next i
endfunction

function Game( gameNumber )
Background = (CreateSprite(LoadImage("Background6.png")))

StopMusic()

LoadImage( 1, "WRoundedSolid.png" )
LoadImage( 2, "WRoundedShaded.png" )
LoadImage( 3, "WRoundedOutline.png" )
LoadImage( 4, "WSquiggleSolid.png" )
LoadImage( 5, "WSquiggleShaded.png" )
LoadImage( 6, "WSquiggleOutline.png" )
LoadImage( 7, "WDiamondSolid.png" )
LoadImage( 8, "WDiamondShaded.png" )
LoadImage( 9, "WDiamondOutline.png")
LoadImage( 10, "EmptyCard.png" )
LoadImage( 12, "ClickedCard.png" )
LoadImage( 13, "CardTable.png" )
LoadImage( 14, "Clock.png" )
LoadImage( 16, "Logo.png" )
LoadImage( 17, "SwapButton.png" )
LoadImage( 18, "PauseButton.png" )
LoadImage( 19, "WrongCards.png" )
LoadImage( 20, "EndGame.png" )
LoadImage( 21, "YourScore.png" )
LoadImage( 22, "PlayAgain.png" )
LoadImage( 23, "Home.png" )
LoadImage( 24, "PauseScreen.png" )
LoadImage( 25, "PlayButton.png" )
LoadImage( 26, "QuitGame2.png" )
LoadSound( 1, "RegularClock.wav" )
LoadSound( 3, "Buzzer.wav" )
LoadSound( 4, "Wrong.wav" )
LoadSound( 5, "Select.wav" )
LoadSound( 6, "Ding.wav" )
LoadSound( 7, "Coin.wav" )
LoadSound( 8, "ChaChing.wav" )
LoadSound( 9, "DingLing.wav" )
LoadSound( 10, "switch_converted(1).wav" )
LoadSound( 11, "pause_converted.wav" )
LoadSound( 12, "Card.wav" )
LoadSound( 13, "Swoosh.wav" )

xCoordinate = 25
yCoordinate = 90
global minutes = 3
global seconds = 00
count = 0
cardNumber = 12
global score = 0
global time = 0
Dim CardProperties# [ 4, 20 ]
Dim Set# [ 3 ]
global symbolId = 1000

CreateSprite( 20, 18 )
SetSpriteScale( 20, .5, .5 )
SetSpritePosition( 20, 0, 430)

CreateSprite( 16, 13 )
SetSpritePosition( 16, 0, 65 )

for i = 1 to 12
    if xCoordinate > 240
        xCoordinate = 25
        yCoordinate = yCoordinate + 100
    endif

    MakeCard( i, xCoordinate, yCoordinate )

    xCoordinate = xCoordinate + 70
next i

CreateSprite( 17, 14 )

CreateSprite( 19, 17 )
SetSpriteScale( 19, 1.2, 1.2 )
SetSpritePosition( 19, 114, 423)

CreateText( 1, STR(minutes) + ":0" + STR(seconds))
SetTextSize (1, 32)
SetTextPosition (1, 45, 6)
SetTextColor( 1, 255, 255, 255, 255 )

CreateText( 2, "00" )
SetTextAlignment( 2, 2)
SetTextSize( 2, 32 )
SetTextPosition( 2, 320, 6 )
SetTextColor( 2, 255, 255, 255, 255 )

do
    Clock()

    if time - WrongTime = 30
        for i = 1 to 12
            if GetSpriteImageId(i)=19
                SetSpriteImage( i, 10 )
                StopSound( 4 )
                SetTextColor( 2, 255, 255, 255, 255 )
            endif
        next i
    endif

    if RightTime > 0
        SetTextColor( 2, 255, 255, 255, 255 )
        RightTime = 0
    endif

    // clicking on a card
    if GetPointerPressed()=1
        for object = 1 to 12
            if GetSpriteHitTest( object, GetPointerX(), GetPointerY() )=1
                if GetSpriteImageId( object ) = 10
                    SetSpriteImage( object, 12 )
                else
                    SetSpriteImage( object, 10)
                endif
                PlaySound( 5 )
            endif
        next object
    endif

    // determining if three cards are selected
    for object = 1 to 12
        if GetSpriteImageId( object ) = 12
            count = count + 1
            Set# [ count ] = object
        endif
    next object

    // determining if set is correct or incorrect
    if count = 3
        first = Set# [ 1 ]
        second = Set# [ 2 ]
        third = Set# [ 3 ]

        if ( ( CardProperties# [ 1, first ] = CardProperties# [ 1, second ] And CardProperties# [1, first] = CardProperties# [ 1, third ]) Or (CardProperties# [ 1, first ] <> CardProperties# [ 1, second ] And CardProperties# [ 1, second ] <> CardProperties# [ 1, third ] And CardProperties# [ 1, first ] <> CardProperties# [ 1, third ] ) ) And ( ( CardProperties# [ 2, first ] = CardProperties# [ 2, second ] And CardProperties# [2, first] = CardProperties# [ 2, third ]) Or (CardProperties# [ 2, first ] <> CardProperties# [ 2, second ] And CardProperties# [ 2, second ] <> CardProperties# [ 2, third ] And CardProperties# [ 2, first ] <> CardProperties# [ 2, third ] ) ) And ( ( CardProperties# [ 3, first ] = CardProperties# [ 3, second ] And CardProperties# [3, first] = CardProperties# [ 3, third ]) Or (CardProperties# [ 3, first ] <> CardProperties# [ 3, second ] And CardProperties# [ 3, second ] <> CardProperties# [ 3, third ] And CardProperties# [ 3, first ] <> CardProperties# [ 3, third ] ) ) And ( ( CardProperties# [ 4, first ] = CardProperties# [ 4, second ] And CardProperties# [4, first] = CardProperties# [ 4, third ]) Or (CardProperties# [ 4, first ] <> CardProperties# [ 4, second ] And CardProperties# [ 4, second ] <> CardProperties# [ 4, third ] And CardProperties# [ 4, first ] <> CardProperties# [ 4, third ] ) )
            Score = Score + 1
            if Score < 10 and score >= 0
                SetTextString( 2, "0" + STR( Score ) )
            else
                SetTextString( 2, Str( Score) )
            endif
            count = 0

            PlaySound( Random( 6, 8 ) )
            SetTextColor( 2, 0, 255, 0, 255)

            x1 = GetSpriteX( Set# [ 1 ] )
            y1 = GetSpriteY( Set# [ 1 ] )
            x2 = GetSpriteX( Set# [ 2 ] )
            y2 = GetSpriteY( Set# [ 2 ] )
            x3 = GetSpriteX( Set# [ 3 ] )
            y3 = GetSpriteY( Set# [ 3 ] )

            DisposeCards( Set#[ 1 ], Set#[ 2 ], Set#[ 3 ] )

            DeleteSprite( Set#[ 1 ] )
            MakeCard( Set#[ 1 ], x1, y1 )

            DeleteSprite( Set#[ 2 ] )
            MakeCard( Set#[ 2 ], x2, y2 )

            DeleteSprite( Set#[ 3 ] )
            MakeCard( Set#[ 3 ], x3, y3 )

            RightTime = time
        else
            SetSpriteImage( first, 19 )
            SetSpriteImage( second, 19 )
            SetSpriteImage( third, 19 )
            PlaySound( 4 )
            score = score - 1
            if Score < 10 and score >=0
                SetTextString( 2, "0" + STR( Score ) )
            else
                SetTextString( 2, Str( Score) )
            endif

            SetTextColor( 2, 255, 0, 0, 255 )

            WrongTime = time
        endif

    endif

    // clicking swap or pause
    if GetPointerPressed() = 1
        if GetSpriteHitTest( 19, GetPointerX(), GetPointerY() ) and GetSpriteColorAlpha( 19 )=255
            SetSpriteColorAlpha( 19, 100 )
            SplitTime = time
            SwapCards()
        endif
        if GetSpriteHitTest( 20, GetPointerX(), GetPointerY() )
            Pause( gameNumber )
        endif
    endif

    if GetSpriteColorAlpha( 19 )=100
        if time - SplitTime >= 900
            SetSpriteColorAlpha( 19, 255 )
        endif
    endif

    count = 0

    sync()
loop

endfunction

function SwapCards()
    CreateSprite( 2000, 16 )
    SetSpritePosition( 2000, -395, 200)

    xCoordinate = 25
    yCoordinate = 90
    Accel# = .1
    Rand# = Random ( 5, 10 ) / 5

    PlaySound( 10 )

    while counter < 95
        if GetSpriteX(1)<480
            for i = 1 to 12
                SetSpriteX( i, GetSpriteX(i)+Accel# )
            next i
            for j = 1000 to symbolId - 1
                SetSpriteX( j, GetSpriteX(j)+Accel#)
            next j
            SetSpriteX( 2000, GetSpriteX(2000)+Accel#)

            Clock()
            sync()
            Accel# = Accel# + .1
        endif
        if GetSpriteX(1)>480
            for i = 1 to 12
                DeleteSprite( i )
                if xCoordinate > 240
                    xCoordinate = 25
                    yCoordinate = yCoordinate + 100
                endif

                MakeCard( i, xCoordinate, yCoordinate )

                xCoordinate = xCoordinate + 70

                SetSpriteColorAlpha( 2000, GetSpriteColorAlpha( 2000 )-23 )
            next i
        endif

        counter = counter + 1
    endwhile

    DeleteSprite( 2000 )

endfunction

function Clock()
    time = time + 1
    if time mod 60 = 0 and time <= 10800
        if seconds = 0
            minutes = minutes - 1
            seconds = 59
        else
            seconds = seconds - 1
        endif
    endif

    if seconds < 10
        SetTextString(1, Str(minutes) + ":0" + STR(seconds))
    else
        SetTextString (1, STR(minutes) + ":" + STR(seconds))
    endif

    if seconds = 10 and minutes = 0 and time mod 60 = 0
        PlaySound( 1, 50, 1 )
    endif

    if seconds <= 10 and seconds > 0 and minutes = 0
        if time mod 30 = 0
            if GetTextColorBlue( 1 ) = 0
                SetTextColor( 1, 255, 0, 0, 255 )
            else
                SetTextColor( 1, 255, 255, 255, 255 )
            endif
        endif
    endif

    if seconds = 0 and minutes = 0
        StopSound( 1 )
        StopSound( 4 )
        EndGame()
    endif
endfunction

function MakeCard( id, xCoordinate, yCoordinate )
    PlaySound( 12 )

    CreateSprite (id, 10)
    SetSpritePosition (id, xCoordinate, yCoordinate)
    SetSpriteColorAlpha( id, 0 )

    color = random (1, 3)
    number = random (1, 3)
    kind = random (1, 9)
    initialId = symbolId
    shape# = kind
    shape# = shape# / 3

    while someCounter < 12
        someCounter = someCounter + 1
        if GetSpriteExists( someCounter )=1
            if someCounter <> id
                if CardProperties# [ 1, someCounter ] = number and CardProperties# [ 2, someCounter ] = color and CardProperties# [ 3, someCounter ] = kind mod 3 and CardProperties# [ 4, someCounter ] = ceil( shape# )
                    color = random (1, 3)
                    number = random (1, 3)
                    kind = random (1, 9)
                    initialId = symbolId
                    shape# = kind
                    shape# = shape# / 3
                    someCounter = 0
                endif
            endif
        endif
    endwhile


    CardProperties# [ 1, id ] = number
    CardProperties# [ 2, id ] = color
    CardProperties# [ 3, id ] = kind mod 3
    CardProperties# [ 4, id ] = ceil( shape# )

    if number = 1
        CreateSprite (symbolId, kind)
        SetSpriteOffset (symbolId, GetSpriteWidth(symbolId)/2, GetSpriteHeight(symbolId)/2)
        SetSpritePositionbyOffset (symbolId, xCoordinate + GetSpriteWidth(id)/2, yCoordinate + GetSpriteHeight(id)/2)
        if color = 1
            SetSpriteColor( symbolId, 54, 3, 55, 0 )
        endif
        if color = 2
            SetSpriteColor( symbolId, 255, 0, 0, 0 )
        endif
        if color = 3
            SetSpriteColor( symbolId, 19, 162, 0, 0 )
        endif

        symbolId = symbolId + 1
    endif
    if number = 2
        CreateSprite (symbolId, kind)
        SetSpriteOffset (symbolId, GetSpriteWidth(symbolId)/2, GetSpriteHeight(symbolId)/2)
        SetSpritePositionbyOffset (symbolId, xCoordinate + GetSpriteWidth(id)/2, yCoordinate + GetSpriteHeight(id)/2 - 14)

        CreateSprite (symbolId + 1, kind)
        SetSpriteOffset (symbolId + 1, GetSpriteWidth(symbolId + 1)/2, GetSpriteHeight(symbolId + 1)/2)
        SetSpritePositionbyOffset (symbolId + 1, xCoordinate + GetSpriteWidth(id)/2, yCoordinate + GetSpriteHeight(id)/2 + 14)

        if color = 1
            SetSpriteColor( symbolId, 54, 3, 55, 0 )
            SetSpriteColor( symbolId + 1, 54, 3, 55, 0 )
        endif
        if color = 2
            SetSpriteColor( symbolId, 255, 0, 0, 0 )
            SetSpriteColor( symbolId + 1, 255, 0, 0, 0 )
        endif
        if color = 3
            SetSpriteColor( symbolId, 19, 162, 0, 0 )
            SetSpriteColor( symbolId + 1, 19, 162, 0, 0 )
        endif

        symbolId = symbolId + 2
    endif
    if number = 3
        CreateSprite (symbolId, kind)
        SetSpriteOffset (symbolId, GetSpriteWidth(symbolId)/2, GetSpriteHeight(symbolId)/2)
        SetSpritePositionbyOffset (symbolId, xCoordinate + GetSpriteWidth(id)/2, yCoordinate + GetSpriteHeight(id)/2 - 28)

        CreateSprite (symbolId + 1, kind)
        SetSpriteOffset (symbolId + 1, GetSpriteWidth(symbolId + 1)/2, GetSpriteHeight(symbolId + 1)/2)
        SetSpritePositionbyOffset (symbolId + 1, xCoordinate + GetSpriteWidth(id)/2, yCoordinate + GetSpriteHeight(id)/2)

        CreateSprite (symbolId + 2, kind)
        SetSpriteOffset (symbolId + 2, GetSpriteWidth(symbolId + 2)/2, GetSpriteHeight(symbolId + 2)/2)
        SetSpritePositionbyOffset (symbolId + 2, xCoordinate + GetSpriteWidth(id)/2, yCoordinate + GetSpriteHeight(id)/2 + 28)

        if color = 1
            SetSpriteColor( symbolId, 54, 3, 55, 0 )
            SetSpriteColor( symbolId + 1, 54, 3, 55, 0 )
            SetSpriteColor( symbolId + 2, 54, 3, 55, 0 )
        endif
        if color = 2
            SetSpriteColor( symbolId, 255, 0, 0, 0 )
            SetSpriteColor( symbolId + 1, 255, 0, 0, 0 )
            SetSpriteColor( symbolId + 2, 255, 0, 0, 0 )
        endif
        if color = 3
            SetSpriteColor( symbolId, 19, 162, 0, 0 )
            SetSpriteColor( symbolId + 1, 19, 162, 0, 0 )
            SetSpriteColor( symbolId + 2, 19, 162, 0, 0 )
        endif

        symbolId = symbolId + 3
    endif

    while counting < 10
        for i = initialId to symbolId - 1
            SetSpriteColorAlpha( i, GetSpriteColorAlpha(i) + 25 )
        next i
        SetSpriteColorAlpha( id, GetSpriteColorAlpha(id) + 25 )

        if GetTextExists( 1 )=1
            Clock()
        endif

        sync()
        counting = counting + 1
    endwhile
endfunction

function DisposeCards( first, second, third )
    SetSpriteImage( first, 10 )
    SetSpriteImage( second, 10 )
    SetSpriteImage( third, 10 )

    yMove1 = ( 0 + GetSpriteY( first ) ) / ( 320 - GetSpriteX( first ) ) * ( ( 320 - GetSpriteX( first ) ) / 30 )
    yMove2 = ( 0 + GetSpriteY( second ) ) / ( 320 - GetSpriteX( second ) ) * ( ( 320 - GetSpriteX( second ) ) / 30 )
    yMove3 = ( 0 + GetSpriteY( third ) ) / ( 320 - GetSpriteX( third ) ) * ( ( 320 - GetSpriteX( third ) ) / 30 )

    for i = 1000 to symbolId
        if GetSpriteExists( i )=1
            if GetSpriteHitTest( first, GetSpriteX( i ), GetSpriteY( i ) ) = 1 or GetSpriteHitTest( third, GetSpriteX( i ), GetSpriteY( i ) ) = 1 or GetSpriteHitTest( second, GetSpriteX( i ), GetSpriteY( i ) ) = 1
                SetSpriteColorAlpha( i, 0 )
            endif
        endif
    next i

    while g < 60
        SetSpritePosition( first, GetSpriteX( first ) + ( 320 - GetSpriteX( first ) ) / 30, GetSpriteY( first ) - yMove1 )
        SetSpritePosition( second, GetSpriteX( second ) + ( 320 - GetSpriteX( second ) ) / 30, GetSpriteY( second ) - yMove2 )
        SetSpritePosition( third, GetSpriteX( third ) + ( 320 - GetSpriteX( third ) ) / 30, GetSpriteY( third ) - yMove3 )

        Clock()

        sync()

        g = g + 1
    endwhile


endfunction

function EndGame()
    DeleteText( 1 )
    DeleteText( 2 )

    CreateSprite( 300, 20 )
    SetSpritePosition( 300, 0, -480 )

    time = 0
    move# = 0

    while GetSpriteY( 300 ) < 0
        time = time + 1
        if GetSpriteY( 300 ) + move# < 0
            SetSpriteY( 300, GetSpriteY( 300 ) + move# )
        else
            SetSpriteY( 300, GetSpriteY( 300 ) + (0 - GetSpriteY(300)) )
        endif
        sync()
        if time = 10
            PlaySound( 13 )
        endif
        move# = move# + 1
    endwhile

    time = 0
    currentScore = 0

    do
        sync()
        time = time + 1
        if time = 30
            CreateSprite( 301, 21 )
            SetSpritePosition( 301, 60, 220 )
            PlaySound( 6 )
        elseif time = 60
            CreateText( 50, "00" )
            SetTextPosition( 50, 235, 221)
            SetTextSize( 50, 28 )
        endif
        if time > 60 and time mod 4 = 0 and currentScore < score
            PlaySound( 6 )
        endif
        if GetTextExists( 50 )=1
            if time mod 4 = 0
                if currentScore < score
                    currentScore = currentScore + 1
                endif
                if currentScore < 10
                    SetTextString( 50, "0" + str(currentScore) )
                else
                    SetTextString( 50, str(currentScore) )
                endif
            endif
        endif
        if currentScore = score and GetSpriteExists( 302 )=0
            CreateSprite( 302, 22 )
            SetSpritePosition( 302, 70, 330 )
            if GetMusicExists( 1 ) = 1 and GetMusicExists( 2 ) = 0
                LoadMusic( 2, "SecondSoundtrack.mp3" )
                PlayMusic( 2 )
            elseif GetMusicExists( 1 ) = 1 and GetMusicExists( 2 ) = 1 and GetMusicPlaying() = 0
                PlayMusic( 2 )
            endif
        endif
        if currentScore = score and GetSpriteExists( 303 )=0
            CreateSprite( 303, 23 )
            SetSpriteScale( 303, .4, .4 )
            SetSpritePosition( 303, 5, 434 )
        endif

        if GetPointerPressed()=1
            if GetSpriteExists( 302 )=1
                if GetSpriteHitTest( 302, GetPointerX(), GetPointerY() )=1
                    Delete()
                    Game( 0 )
                endif
            endif
            if GetSpriteExists( 303 )=1
                if GetSpriteHitTest( 303, GetPointerX(), GetPointerY() )=1
                    Delete()
                    Menu()
                endif
            endif
        endif
    loop

endfunction

function Pause( GameNumber )
    if GetSoundsPlaying( 1 )>0
        StopSound( 1 )
        sounding = 1
    else
        sounding = 0
    endif

    PlaySound( 11 )

    CreateSprite( 250, 24 )
    SetSpritePosition( 250, 0, 65 )
    SetSpriteImage( 20, 25 )

    CreateSprite( 251, 26 )
    SetSpritePosition( 251, 110, 300 )

    do
        sync()
        if GetPointerPressed()=1 and GetSpriteHitTest( 20, GetPointerX(), GetPointerY() )=1
            SetSpriteImage( 20, 18 )
            SetSpriteX( 250, GetSpriteX( 250 ) - 320 )
            PlaySound(11)
            sync()
            DeleteSprite( 250 )
            DeleteSprite( 251 )
            if sounding = 1
                PlaySound( 1, 50, 1 )
            endif
            return
        endif
        if GetPointerPressed()=1 and GetSpriteHitTest( 251, GetPointerX(), GetPointerY() )=1
            if GameNumber = 0
                Delete()
                Menu()
            else
                PlaySound( LoadSound( "Warning.wav" ) )
                CreateSprite( 252, LoadImage( "BlackScreen.bmp" ) )
                SetSpriteColorAlpha( 252, 150 )
                CreateSprite (253, LoadImage( "Warning.png" ) )
                SetSpriteScale( 253, 1.2, 1.2)
                SetSpritePosition( 253, 10, 160 )
                CreateSprite( 254, LoadImage( "Okay.png" ) )
                SetSpritePosition( 254, 60, 220 )
                CreateSprite( 255, LoadImage( "Return.png" ) )
                SetSpritePosition( 255, 167, 219 )

                do
                    if GetPointerPressed()=1 and GetSpriteHitTest( 254, GetPointerX(), GetPointerY() )=1
                        Delete()
                        Menu()
                    endif
                    if GetPointerPressed()=1 and GetSpriteHitTest( 255, GetPointerX(), GetPointerY() )=1
                        for i = 252 to 255
                            DeleteSprite( i )
                        next i
                        exit
                    endif
                    sync()
                loop
            endif
        endif
    loop
endfunction    