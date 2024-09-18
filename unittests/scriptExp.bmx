SuperStrict
Framework Brl.StandardIO
Import Brl.StringBuilder

Import "../source/Dig/base.util.graphicsmanager.bmx"
Import "../source/game.database.bmx"
Import "../source/game.gamescriptexpression.bmx"
Import "../source/game.stationmap.bmx"
Import "../source/game.registry.loaders.bmx"
Import "../source/game.player.difficulty.bmx"
Import "scriptExpHelper.bmx"

startUi()

Global basePath:String = "../" 'ex for TVTower/Tests/test01.bmx
TPlayerDifficultyCollection._basePath = basePath
Global registryLoader:TRegistryLoader = New TRegistryLoader
registryLoader.baseURI = basePath


registryLoader.LoadFromXML("config/programmedatamods.xml", True)
GetMovieGenreDefinitionCollection().Initialize()


TLocalization.LoadLanguages(registryLoader.baseURI + "res/lang")
'set default languages
TLocalization.SetDefaultLanguage("en")
TLocalization.SetCurrentLanguage("de")


'required BEFORE loading programmes (for relative birthday dates)
GetWorldTime().SetStartYear(1985)

'load entire db
LoadDB(Null, basePath)

'load single entries
'LoadDB(["database_scripts.xml"], basePath)
'LoadDB(["database_people.xml"], basePath)
'LoadDB(["database_programmes.xml"], basePath)
'LoadDB(["scripts_new.xml_"], basePath)
'load from local xml?
'New TDatabaseLoader().Load("test.scriptexpression_ng.db.xml")


'load stationmap (AFTER time is set - so antenna share ratio is known)
GetStationMapCollection().LoadMapFromXML("res/maps/germany/germany.xml", registryLoader.baseURI)

'SeedRand(1000) 'same seed (replicate output!)


checkDatabaseConsistency()
'checkSimpleCsv()
'checkScriptTemplateVariables()
'checkScriptJobs()
'checkCastReplacement()


'
' =========================
'

Function checkDatabaseConsistency()
	print "=== TEST 0 ================================================"
	for local yoffset:int = 1 until 2
		GetWorldTime().SetStartYear(1980+yoffset*5)
		print "  == for year "+(1980+yoffset*5)
		for local lng:String = eachin ["de","en","pl"]
			TLocalization.SetCurrentLanguage(lng)
			checkLicences()
			checkScripts()
			checkNews()
			checkAds()
		next
	next
End Function




Function checkScriptTemplateVariables()
	print "=== TEST 1 ================================================"
	Local template:TScriptTemplate = GetScriptTemplateCollection().GetByGUID("scripttemplate-random-ron-averagedayseries01")
	Local title:String = template.GetTitle()
	'hasVariable(template.title)
	rem
	print "template variables:"
	print "==================="
	print template.templateVariables.GetVariablesAsText()
	print "==================="
	endrem
	'print GameScriptExpression.ParseLocalizedText(title, template, TLocalization.GetLanguageID("de")).ToString()
	'print GameScriptExpression.ParseLocalizedText(title, template, TLocalization.GetLanguageID("en")).ToString()
	rem
	print "==================="
	print "template resolved variables:"
	print "==================="
	print template.templateVariables.GetResolvedVariablesAsText()
	endrem
	print "==========================================================="
End Function


Function checkSimpleCsv()
	print "output: ~q" + GameScriptExpression.Parse("${.csv:~q    ~nhello;world~q   :1}").GetValueText() +"~q"
	print "output: ~q" + GameScriptExpression.Parse("${.csv:~q    ~nhello;world~q   :0}").GetValueText() +"~q"
	print "output: ~q" + GameScriptExpression.Parse("${.csv:~q    ~nhello;world~q   :0:~q;~q:0}").GetValueText() +"~q"
End Function



Function checkScriptJobs()
	print "=== TEST 2 ================================================"
	'GetScriptCollection().GenerateFromTemplate("scripttemplate-random-ron-fightagainst01")
	'GetScriptCollection().GenerateFromTemplate("scripttemplate-random-ron-subtilehumor01")
	'GetScriptCollection().GenerateFromTemplate("scripttemplate-random-ron-show1")
	'GetScriptCollection().GenerateFromTemplate("scripttemplate-random-ron-test")
	GetScriptCollection().GenerateFromTemplate("theId")
	
	local scriptNum:Int = 0
	for local script:TScript = eachin GetScriptCollection().GetAvailableScriptList()
		If scriptNum > 0 
			print "==================="
		EndIf
		print script.GetTitle()
		print " D: "+script.GetDescription()
		
		local jobs:String
		for local j:TPersonProductionJob = EachIn script.GetJobs()
			jobs :+ "job="+j.job + "(g="+j.gender+")  "
		Next
		print " J: "+jobs
	
		For local subScript:TScript = eachin script.subScripts
			print "  - "+subScript.GetTitle()
			print "    D: "+subScript.GetDescription()
		Next
		
		scriptNum :+ 1
	next
	print "==========================================================="
End Function


Function checkCastReplacement()
	print "=== TEST 3 ================================================"
	'Licence check ("cast" replacement)
	Local licence:TProgrammeLicence = GetProgrammeLicenceCollection().GetByGUID("3bd76bd9-3cb7-4a9d-8e57-815b1ea7c2f0")
	print "T: " + licence.GetTitle()
	print "D: " + licence.GetDescription()
	print "==========================================================="
	
	
	'local xml stuff ...
	print "=== TEST 4 ================================================"
	licence = GetProgrammeLicenceCollection().GetByGUID("test-programme-1")
	print "T: " + licence.GetTitle()
	print "D: " + licence.GetDescription()
	print "==========================================================="
End Function