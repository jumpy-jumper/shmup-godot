extends Node

var frametime = 1.0 / 60.0
var framerate = 1.0 / frametime

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
