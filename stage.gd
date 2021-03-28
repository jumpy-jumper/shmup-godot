extends Node


signal beat(strength)


export var bpm = 60.0
export var beat_strength = 1.5

var act_time = 0


func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

	if (act_time % int((1.0 / bpm) * 60 * Manager.framerate)) == 0:
		emit_signal("beat", beat_strength)

	act_time += 1


func _on_Stage_beat(strength):
	pass
