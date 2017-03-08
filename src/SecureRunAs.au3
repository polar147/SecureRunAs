#NoTrayIcon
#include <AutoItConstants.au3>
#include <Array.au3>
#include <Crypt.au3>

$sKey= "YourKeyGoesHere!"
if $CmdLine[0] > 1 then
	Switch StringUpper($CmdLine[1])
		Case "GEN"
			if $CmdLine[0] > 5 then
				ConsoleWrite("Hash command:"& @CRLF & @CRLF & generate($CmdLine[2],$CmdLine[3],$CmdLine[4],$CmdLine[5],$CmdLine[6]) & @CRLF)
			else
				ConsoleWrite("The command has few arguments for this option")
				help()
			endif
		Case "EXEC"
			if $CmdLine[0] > 2 then
				exec($CmdLine[2],$CmdLine[3])
			else
				ConsoleWrite("The command has few arguments for this option")
				help()
			endif
		Case "SH377"	
			shell($CmdLine[2],$CmdLine[3])
		Case Else
			help()
	EndSwitch
else
	help()
endif

func generate($sTypeOfRun, $sDomain, $sUserName, $sPassword, $sApplication)
	$sToEncrypt = $sTypeOfRun & "|" & $sDomain & "|" & $sUserName & "|" & $sPassword & "|" & _Crypt_HashFile($sApplication, $CALG_SHA1)
	Return _Crypt_EncryptData($sToEncrypt, $sKey, $CALG_AES_256)
endfunc

func shell($sApplication,$sShowFlag)
	Switch $sShowFlag
		Case "NORMAL"
			ShellExecute ($sApplication, "", "", "", @SW_SHOW)
		Case "HIDE"
			ShellExecute ($sApplication, "", "", "", @SW_HIDE)
	EndSwitch
endfunc

func exec($sHash, $sApplication)
	$aData = StringSplit( BinaryToString(_Crypt_DecryptData($sHash, $sKey, $CALG_AES_256)), "|")
	if $aData[0] > 4 then

		$sHashFileToRun = _Crypt_HashFile($sApplication, $CALG_SHA1)
		;msgbox(0,"" ,$sHashFileToRun & @CRLF & $aData[5])
		if $sHashFileToRun == $aData[5] then
			RunAs ( $aData[3], $aData[2], $aData[4], $RUN_LOGON_PROFILE, '"'&@AutoItExe & '" '& ' SH377 "' & $sApplication & '" ' & StringUpper($aData[1]),'', @SW_HIDE, '')
		else
			ConsoleWrite("The hash of file " & $sApplication & " does not match with hash inside the Hash Command. If you have updated/changed the executable please generate again the Hash Command.")
		endif
	endif
endfunc


func help()
	ConsoleWrite(@CRLF &"SecureRunAs [option] [sub options of each command]" & @CRLF & @CRLF)
	ConsoleWrite("Options:" & @CRLF & @CRLF)
	ConsoleWrite("GEN  generate the hash command" & @CRLF)
	ConsoleWrite("EXEC      run aplication" & @CRLF& @CRLF & @CRLF & @CRLF)
	ConsoleWrite("Examples:" & @CRLF & @CRLF)
	ConsoleWrite("GEN [window type (HIDE or NORMAL)] [domain] [user name] [password] [executable]" & @CRLF)
	ConsoleWrite("EXEC [hash command] [executable]" & @CRLF & @CRLF)
	ConsoleWrite("Made by Andrei Bernardo Simoni")
endfunc






