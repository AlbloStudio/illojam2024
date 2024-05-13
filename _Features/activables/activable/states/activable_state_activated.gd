class_name ActivableStateActivated extends ActivableState


func enter(_msg := {}) -> void:
	SignalBus.activable_activated_done.connect(activated_done, CONNECT_ONE_SHOT)

	var initial_point = (
		state_owner.alternative_initial_point
		if state_owner.alternative
		else state_owner.initial_point
	)

	SignalBus.activable_activated.emit(
		state_owner.activable_name, state_owner.alternative, initial_point
	)

	state_owner.activated_game_feel()


func exit() -> void:
	state_owner.activate_lights(false)


func activated_done(activable_name: String) -> void:
	if activable_name != state_owner.activable_name:
		return

	var audio_to_play = (
		state_owner.alternative_sound if state_owner.alternative else state_owner.sound
	)

	if audio_to_play:
		var time_to_wait = (
			state_owner.alternative_sound_delay
			if state_owner.alternative
			else state_owner.sound_delay
		)

		var volume_to_set = (
			state_owner.alternative_sound_volume
			if state_owner.alternative
			else state_owner.sound_volume
		)

		await get_tree().create_timer(time_to_wait).timeout
		play_audio(audio_to_play, volume_to_set)

	(
		create_tween()
		. tween_callback(
			func(): state_machine.transition_to(state_owner.state_deactivated.name, {"init": false})
		)
		. set_delay(0.3)
	)


func play_audio(audio_to_play: AudioStream, volume: float) -> void:
	state_owner.audio_stream.volume_db = volume
	state_owner.audio_stream.stream = audio_to_play
	state_owner.audio_stream.play()
