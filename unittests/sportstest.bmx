SuperStrict
Framework Brl.StandardIO
Import "../source/game.stationmap.bmx"
Import "../source/Dig/base.util.persongenerator.bmx"
Import "../source/Dig/base.util.mersenne.bmx"
Import "../source/Dig/base.util.math.bmx"
Import "../source/Dig/base.util.string.bmx"
'load sports
Import "../source/game.newsagency.bmx"
Import "../source/game.programmeproducer.bmx" 'sport match programme licences
Import "../source/game.programmeproducer.sport.bmx" 'sport match programme licences

'SeedRand(Millisecs())
'SeedRand(0)

TLocalization.LoadLanguages("../res/lang")
'TLocalization.LoadLanguageFiles("../res/lang/lang_*.txt")
'set default languages
'TLocalization.SetFallbackLanguage("en")
TLocalization.SetCurrentLanguage("de")


'load city names
GetStationMapCollection().LoadMapFromXML("res/maps/germany/germany.xml", "../")


GetWorldTime().SetStartYear(1985)
GetWorldTime().SetTimeFactor(3600 * 24) '12hrs per real second


'EventManager.registerListenerFunction( "Sport.StartSeason", MY_onSportStartSeason )
EventManager.registerListenerFunction( "SportLeague.RunMatch", MY_onRunMatch )
EventManager.registerListenerFunction( GameEventKeys.ProgrammeLicenceCollection_OnAddLicence, CheckAddedSportsprogramme )

'if there is only ONE producer for special stuff - add this way
GetProgrammeProducerCollection().Add( TProgrammeProducerSport.GetInstance().Initialize() )
TLogger.Log("PrepareNewGame()", "Generated sport programme producer (id=" + TProgrammeProducerSport.GetInstance().id+").", LOG_DEBUG)



Local start:Int = MilliSecs()
GetNewsEventSportCollection().CreateAllLeagues()
GetNewsEventSportCollection().StartAll( Long(GetWorldTime().GetTimeGoneForGameTime(GetWorldTime().GetYear()-1,0,0,0,0)) )



global observedLicence:TProgrammeLicence
Local lastUpdate:Int = 0
Local run:Int = 0 
Repeat
	GetWorldTime().Update()

	GetNewsEventSportCollection().UpdateAll()
	
	GetProgrammeProducerCollection().UpdateAll()


	Local minute:Int = GetWorldTime().GetDayMinute()

'	If minute Mod 5 = 0
		GetProgrammeDataCollection().UpdateLive()
'	EndIf

	'=== UPDATE DYNAMIC DATA PROGRAMME ===
	'(do that AFTER setting the broadcasts, so the programme data
	' knows whether it is broadcasted currently or not)
	'Calls UpdateDynamicData() of the programme so it could adjust
	'values like description, title or other values
	'Example: programme data for the "header" of soccer leagues could
	'         tell about "live on tape" or "currently run" matches
'	If minute Mod 5 = 0 'minute = 5 or minute = 55
		GetProgrammeDataCollection().UpdateDynamicData()
'	EndIf



	If observedLicence
		local spdata:TSportsProgrammeData = TSportsProgrammeData(observedLicence.data)
		If spdata.GetMatchTime() <= GetWorldTime().GetTimeGone() and spdata.GetMatchEndTime() >= GetWorldTime().GetTimeGone()
			print GetWorldTime().GetFormattedGameDate()
			print " t: " + observedLicence.GetTitle()
			print " d: " + observedLicence.GetDescription()
		EndIf
	EndIf

'	if GetWorldTime().GetFormattedGameDate() = "9/16:48 (22.09.1985)" '"9/16:24 (21.09.1985)"
'		end
'	EndIf

Until MilliSecs() - start > 150 or GetWorldTime().GetDaysRun() > 30 ' or sportSoccer.ReadyForNextSeason()
print "-- done --"



Function CheckAddedSportsprogramme:Int(event:TEventBase)
	Local licence:TProgrammeLicence = TProgrammeLicence(event.GetReceiver())
	If TSportsHeaderProgrammeData(licence.data)
	'	print "League: " + licence.GetTitle() 
	ElseIf TSportsProgrammeData(licence.data)
	'	print "  Match: " + licence.GetTitle()
		if not observedLicence
			observedLicence = licence
		endif
	EndIf
End Function


Function MY_onSportStartSeason:Int(event:TEventBase)
	Local sport:TNewsEventSport = TNewsEventSport(event.GetSender())
	Local time:Long = Long(event.GetData().GetDouble("time"))

	'ignore past?
	if GetWorldTime().getDay(time) < GetWorldTime().GetStartDay() then return False

	print StringHelper.LsetChar(sport.name, 10, ".")+".| Start Season:  "+GetWorldTime().GetFormattedGameDate(time)
	for local l:TNewsEventSportLeague = Eachin sport.leagues
		print LSet("", 13) + "- "+StringHelper.LSetChar(l.name, 20,".") + ":  " + Rset(GetWorldTime().GetFormattedGameDate(l.GetNextMatchTime()), 21) + "  -  " + RSet(GetWorldTime().GetFormattedGameDate(l.GetLastMatchTime()), 21)
	Next

End Function



Function MY_onRunMatch:Int(event:TEventBase)
	Local league:TNewsEventSportLeague = TNewsEventSportLeague(event.GetSender())
	Local match:TNewsEventSportMatch = TNewsEventSportMatch(event.GetData().Get("match"))
	If Not match Or Not league Then Return False

	'ignore games of the past
	if GetWorldTime().getDay(match.GetMatchTime()) < GetWorldTime().GetStartDay() then return False

	'result generation
	local rShort:string = match.GetReportShort()
	local rLong:string = match.GetReport()

	'print rShort
	'print rLong
	'print "- - -"
End Function
