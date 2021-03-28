extends Area2D
class_name Bullet

export var lifetime = 0

export var speed = 0
export var accel = 0
export var ang_speed = 0
export var ang_accel = 0

var homing_target = null

var potency = 0


func _ready():
	if lifetime > 0:
		$Lifetime.wait_time = lifetime * Manager.frametime
		$Lifetime.start()


func _process(delta):
	ang_speed += ang_accel * Manager.frametime
	speed += accel * Manager.frametime
	# rotational movement
	rotation += deg2rad(ang_speed) * Manager.frametime
	# linear movement
	var posDelta = speed * Manager.frametime
	position.y += posDelta * sin(rotation)
	position.x += posDelta * cos(rotation)

	if homing_target:
		look_at(homing_target.position)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Lifetime_timeout():
	queue_free()
