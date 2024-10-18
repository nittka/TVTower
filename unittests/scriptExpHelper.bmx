SuperStrict
Framework Brl.StandardIO
Import Brl.StringBuilder

Import "../source/Dig/base.util.graphicsmanager.bmx"
Import "../source/game.database.bmx"
Import "../source/game.gamescriptexpression.bmx"
Import "../source/game.stationmap.bmx"
Import "../source/game.registry.loaders.bmx"
Import "../source/game.player.difficulty.bmx"

Const ITERATIONS:Int = 3

Function startUI()
	AppTitle = "TVT: Expression test"
	Local gm:TGraphicsManager = GetGraphicsManager()
	GetGraphicsManager().SetResolution(900,600)
	GetGraphicsManager().InitGraphics()
End Function

Function hasVariable:Int(s:String)
	'TODO common marker for all expression errors would be helpful
	'conversion errors
	'indicators for unresolved variables 
	if s.contains("${") then return True
	if s.contains("[")
		'known exceptions in series
		if s.contains("[li3o9n8e0l1]") then return false
		return True
	endif
	if s.contains("|")
		if s.contains("|b|") then return false
		return True 'alternatives should also not appear!
	endif 
	if s.contains("%")
		'known exceptions (in programmes)
		if s.contains(" 90%.") then return false
		if s.contains(" 100% ") then return false
		'known exceptions (in news a couple of percent values)... 
		if s.contains(" 600% ") then return false
		if s.contains(" 600%.") then return false
		if s.contains(" 200%.") then return false
		if s.contains(" 363% ") then return false
		if s.contains(" 363%ige") then return false
		if s.contains(" alkoholu .36 ") then return false
		if s.contains(" .36 % ") then return false
		if s.contains(" .36 %.") then return false
		if s.contains(" .36%.") then return false
		if s.contains(" 52,1%.") then return false
		if s.contains(" 52,1% ") then return false
		if s.contains(" 52.1% ") then return false
		if s.contains(" 15% ") then return false
		if s.contains(" 28% ") then return false
		if s.contains(" 28%.") then return false
		if s.contains(" .14%.") then return false
		if s.contains(" .14% ") then return false
		if s.contains(" .14 % ") then return false
		if s.contains(" .14 %.") then return false
		if s.contains(" 20%.") then return false
		return True
	endif 
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

Function checkAvailableExpression(e:String, c:Object)
	if e And Not e.contains("${.")
		print e +" -> " + GameScriptExpression.ParseToTrue(e,c)
	endif
End Function

Function checkLicences:int()
	Local col:TProgrammeLicenceCollection = GetProgrammeLicenceCollection()

	For local single:TProgrammeLicence = Eachin col.licences.Values()
		checkLicence(single)
	Next
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

Function checkAds:int()
	Local col:TAdContractBaseCollection = GetAdContractBaseCollection()
	For local t:TAdContractBase = EachIn col.entries.Values()
		checkAvailableExpression(t.availableScript,t)

		'print t.getTitle()
	Next
End Function

Function checkScripts:int()
	Local col:TScriptTemplateCollection = GetScriptTemplateCollection()
	For local t:TScriptTemplate = EachIn col.entries.Values()
		if not t.isEpisode()
			checkScript(t)
		endif
	Next
End Function

Function checkScript:int(t:TScriptTemplate)
	local iterations:Int=1
	checkAvailableExpression(t.availableScript,t)

	if hasVariable(t.GetTitle()) or hasVariable(t.GetDescription())
		'print t.GetTitle()
		'print "  "+ t.GetDescription()
		iterations=ITERATIONS
	endif
	For Local i:Int = 0 Until iterations
		Local script:TScript = GetScriptCollection().GenerateFromTemplate(t.GetGUID())'TScript.createFromTemplate(t, True)
		checkScript(script)
		if script.getSubScriptCount()>0
			For Local i:Int = 0 Until script.getSubScriptCount()
				checkScript(script.getSubScriptAtIndex(i))
			next
		endif
		t.reset()
	Next
End Function

Function checkScript:int(s:TScriptBase)
	Local withV:Int = False
	If hasVariable(s.title) then withV = True
	If hasVariable(s.description) then withV = True
	If withV
		If hasVariable(s.getTitle()) Then print s.getTitle()
		If hasVariable(s.getDescription()) Then print s.getDescription()
	EndIf
End Function

Function checkNews:int()
	Local col:TNewsEventTemplateCollection = GetNewsEventTemplateCollection()
	For local t:TNewsEventTemplate = EachIn col.allTemplatesGUID.Values()
		checkAvailableExpression(t.availableScript,t)

		if t.newsType = TVTNewsType.InitialNews
			local iterations:Int=1
			if hasVariable(t.GetTitle()) or hasVariable(t.GetDescription())
		'		print t.GetTitle()
		'		print "  "+ t.GetDescription()
				iterations=ITERATIONS
			endif
			if t.HasFlag(TVTNewsFlag.INVISIBLE_EVENT) 'trigger event for actual news
				iterations=ITERATIONS
			endif
			'if iterations=1 then continue
			For Local i:Int = 0 Until iterations
				checkNews(t, Null,[])
			Next
		endif
	Next
End Function

Function checkNews:int(t:TNewsEventTemplate, parentVar:TTemplateVariables, checkedIds:String[])
	Local n:TNewsEvent = New TNewsEvent.InitFromTemplate(t, parentVar)
	n.doHappen()
'	if hasVariable(t.GetTitle()) or hasVariable(t.GetDescription())
	if hasVariable(n.GetTitle()) or hasVariable(n.GetDescription())
		print n.GetTitle()
		print "  "+ n.GetDescription()
	endif

	Local vars:TTemplateVariables = n.templateVariables
	'TODO resetting variables to get different news threads does not yet work
	if not parentVar and vars then vars.reset()
	if n.effects and n.effects.entries
		For local list:TList= eachIn n.effects.entries.values()
			For local e:TGameModifierNews_TriggerNews = eachin list
				checkNews(e,vars, checkedIds)
			Next
			For local c:TGameModifierNews_TriggerNewsChoice = eachin list
				For local m:TGameModifierBase = eachIn c.modifiers
					Local ct:TGameModifierNews_TriggerNews = TGameModifierNews_TriggerNews(m)
					checkNews(ct,vars, checkedIds)
				Next
			Next
		Next
	endif
End Function

Function checkNews(effect:TGameModifierNews_TriggerNews, parentVar:TTemplateVariables, checkedIds:String[])
	if effect
		Local t:TNewsEventTemplate =  GetNewsEventTemplateCollection().GetByGUID(effect.triggerNewsGUID)
		if StringHelper.InArray(t.GUID, checkedIds) Then return
		if t and t.newsType <> TVTNewsType.InitialNews
			checkNews(t, parentVar, checkedIds + [t.GUID])
		endif
	endif
End Function