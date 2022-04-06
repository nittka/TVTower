SuperStrict
Import "Dig/base.sfx.soundmanager.base.bmx"
Import "game.figure.base.bmx"
Import "game.player.base.bmx"
Import "game.building.base.sfx.bmx"


Type TFigureBaseSoundSource Extends TSoundSourceElement
	Field figureID:int
	Field _stepSfxSettings:TSfxSettings
	Field _stepsChannel:TSfxChannel {nosave}

	Function Create:TFigureBaseSoundSource (_figure:TFigureBase)
		Local result:TFigureBaseSoundSource = New TFigureBaseSoundSource
		result.figureID = _figure.GetID()
		result._stepsChannel = result.AddDynamicSfxChannel("Steps")

		Return result
	End Function

	Method GetClassIdentifier:String()
		Return "Figure" ' + figureID
	End Method


	Method GetCenter:SVec3D() override
		local f:TFigureBase = GetFigureBaseCollection().Get(figureID)
		if f
			local centerVec:SVec2D = f.area.GetAbsoluteCenterSVec()
			return new SVec3D(centerVec.x, centerVec.y, 0)
		EndIf

		Return new SVec3D
	End Method


	Method IsMovable:Int()
		Return True
	End Method

	Method GetIsHearable:Int()
		If not Self.ChannelInitialized Then Return False
		Return (GetPlayerBase() and not GetPlayerBase().IsInRoom())
	End Method

	Method GetChannelForSfx:TSfxChannel(sfx:String)
		rem
		'TODO initialize and add hello channels in create...
				If Not Self.ChannelInitialized
					'Channel erst hier hinzufügen... am Anfang hat Figure noch keine id
					Self.AddDynamicSfxChannel("Steps" + Self.GetGUID())
					Self.AddDynamicSfxChannel("Hello" + Self.GetGUID())
					Self.AddDynamicSfxChannel("HelloUnfriendly" + Self.GetGUID())
					Self.ChannelInitialized = True
				EndIf
				Return GetSfxChannelByName("Steps" + Self.GetGUID())
		endrem
		Select sfx
			Case "steps"
				Return Self._stepsChannel
			Case "hello"
				If Self.ChannelInitialized
					Return GetSfxChannelByName("Hello" + Self.GetGUID())
				EndIf
			Case "hellounfriendly"
				If Self.ChannelInitialized
					Return GetSfxChannelByName("HelloUnfriendly" + Self.GetGUID())
				EndIf
		EndSelect
	End Method

	Method GetSfxSettings:TSfxSettings(sfx:String)
		Select sfx
			Case "steps"
				Return GetStepsSettings()
			Case "hello"
				Return GetHelloSettings()
			Case "hellounfriendly"
				Return GetHelloUnfriendlySettings()
		EndSelect
	End Method

	Method OnPlaySfx:Int(sfx:String)
		Return True
	End Method

	Method GetStepsSettings:TSfxSettings()
		If not _stepSfxSettings Then _stepSfxSettings = New TSfxFloorSoundBarrierSettings

		'(re)set values
		_stepSfxSettings.nearbyDistanceRange = 60
		_stepSfxSettings.maxDistanceRange = 300
		_stepSfxSettings.nearbyRangeVolume = 0.3
		_stepSfxSettings.midRangeVolume = 0.1
		'_stepSfxSettings.nearbyRangeVolume = 0.15
		'_stepSfxSettings.midRangeVolume = 0.05
		_stepSfxSettings.minVolume = 0

		Return _stepSfxSettings
	End Method

	Method GetHelloSettings:TSfxSettings()
		Local result:TSfxSettings = New TSfxFloorSoundBarrierSettings
		result.nearbyDistanceRange = 60
		result.maxDistanceRange = 100
		result.nearbyRangeVolume = 0.3
		result.midRangeVolume = 0.1

		'result.nearbyRangeVolume = 0.15
		'result.midRangeVolume = 0.05
		result.minVolume = 0
		Return result
	End Method

	Method GetHelloUnfriendlySettings:TSfxSettings()
		Local result:TSfxSettings = New TSfxFloorSoundBarrierSettings
		result.nearbyDistanceRange = 60
		result.maxDistanceRange = 100
		result.nearbyRangeVolume = 0.3
		result.midRangeVolume = 0.1

		'result.nearbyRangeVolume = 0.15
		'result.midRangeVolume = 0.05
		result.minVolume = 0
		Return result
	End Method
End Type
