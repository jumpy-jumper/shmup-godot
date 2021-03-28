extends Node2D

export (PackedScene) var bullet = null

export var count = 1
export var rate = 15
export var lifetime = 60
export var speed = 0.0
export var accel = 0.0
export var ang_speed = 0.0
export var ang_accel = 0.0


func _process(delta):
	$SpawnTimer.wait_time = rate * Manager.frametime


func _on_SpawnTimer_timeout():
	for i in range (count):
		var new = bullet.instance()
		new.lifetime = lifetime
		new.speed = speed
		new.accel = accel
		new.ang_speed = ang_speed
		new.ang_accel = ang_accel
		add_child(new)
