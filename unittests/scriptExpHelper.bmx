SuperStrict
Framework Brl.StandardIO
Import Brl.StringBuilder

Import "../source/Dig/base.util.graphicsmanager.bmx"
Import "../source/game.database.bmx"
Import "../source/game.gamescriptexpression.bmx"
Import "../source/game.stationmap.bmx"
Import "../source/game.registry.loaders.bmx"
Import "../source/game.player.difficulty.bmx"

Function startUI()
	AppTitle = "TVT: Expression test"
	Local gm:TGraphicsManager = GetGraphicsManager()
	GetGraphicsManager().SetResolution(900,600)
	GetGraphicsManager().InitGraphics()
End Function

Function hasVariable:Int(s:String)
	if s.contains("${") then return True
	if s.contains("%") then return True
	if s.contains("[") then return True
	return False
End Function

Function hasVariable:Int(str:TLocalizedString)
	Local result:Int=False
	If str
		For local s:string = EachIn str.valueStrings
			If hasVariable(s) then result = True
		Next
		if result
'			print str.ToString()
		endif
	EndIf
	return result
End Function

Function checkLicences:int()
	Local col:TProgrammeLicenceCollection = GetProgrammeLicenceCollection()

	For local single:TProgrammeLicence = Eachin col.licences.Values()
		checkLicence(single)
	Next
rem
	For local single:TProgrammeLicence = Eachin col.singles.Values()
		checkLicence(single)
	Next
	For local serie:TProgrammeLicence = Eachin col.series.Values()
		checkLicence(serie)
		For local episode:TProgrammeLicence = Eachin serie.subLicences
			checkLicence(episode)
		Next
	Next
	For local collection:TProgrammeLicence = Eachin col.collections.Values()
		checkLicence(collection)
		For local episode:TProgrammeLicence = Eachin collection.subLicences
			checkLicence(episode)
		Next
	Next
endrem
End Function

Function checkLicence:int(l:TProgrammeLicence)
	Local withV:Int = False
	If hasVariable(l.title) then withV = True
	If hasVariable(l.description) then withV = True
	If l.getData()
		If hasVariable(l.getData().title) then withV = True
		If hasVariable(l.getData().description) then withV = True
	EndIf
	If withV
		'print l.getData().description.ToString()
		If hasVariable(l.getTitle()) Then print l.getTitle()
		If hasVariable(l.getDescription()) Then print l.getDescription()
	EndIf
End Function

Function checkScripts:int()
	Local col:TScriptTemplateCollection = GetScriptTemplateCollection()
	For local t:TScriptTemplate = EachIn col.entries.Values()
		checkScript(t)
	Next
End Function

Function checkScript:int(t:TScriptTemplate)
	if hasVariable(t.GetTitle())
		print t.GetTitle()
	endif
	'TODO iterate over multiple creations of the same script (variables with alternatives
	'Local script:TScript = TScript.createFromTemplate(t, True)
	'TODO check sub-scripts as well
	'checkScript(script)
	'print script.GetTitle()
End Function

Function checkScript:int(s:TScript)
	Local withV:Int = False
	rem
	If hasVariable(l.title) then withV = True
	If hasVariable(l.description) then withV = True
	If l.getData()
		If hasVariable(l.getData().title) then withV = True
		If hasVariable(l.getData().description) then withV = True
	EndIf
	If withV
		'print l.getData().description.ToString()
		If hasVariable(l.getTitle()) Then print l.getTitle()
		If hasVariable(l.getDescription()) Then print l.getDescription()
	EndIf
	endrem
End Function
