extends Area2D


export var fade_in_threshold = 0.8

onready var max_alpha = modulate.a


func _process(delta):
	var player_distance_from_center = ($"../Player".position - position).length()
	modulate.a = ((player_distance_from_center / $Shape.shape.radius) - fade_in_threshold) / (1 - fade_in_threshold) * max_alpha


func clamped(pos):
	var diff = pos - position
	if diff.length() > $Shape.shape.radius:
		diff = diff.clamped($Shape.shape.radius)
		return diff + position

	return pos
