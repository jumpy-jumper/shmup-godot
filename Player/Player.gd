extends Area2D

class_name Player

export var speed = 2000.0
export var angular_speed = 100.0
export var focused = false

var target = null

export var visible_green_indicator = true

var red_active = false
var red_trigger_length = 0
var red_angle = 0


export(PackedScene) var bullet = null

export var bullet_count = 5
export var bullet_wait = 3

export var bullet_spread = 150
export var bullet_vertical_offset = 50
export var bullet_arc = 0
export var bullet_speed = 2000
export var bullet_accel = 2000

export (Array, Color) var bullet_color_unfocused = []
export (Array, Color) var bullet_color_focused = []
export var bullet_alpha = 0.5

export var bullet_potency = 10

var bullet_timer = 0

onready var border = $"../Border"

func _ready():
	target = $"../Enemy"

func _process(delta):
	focused = not Input.is_action_pressed("focus")
	red_active = Input.is_action_pressed("red") and target != null
	process_movement()

	if bullet_timer > 0:
		bullet_timer -= 1
	elif not Input.is_action_pressed("fire"):
		fire()

	if target:
		look_at(target.position)
		rotation += deg2rad(90)
	else:
		rotation = 0

	if focused:
		$Sprite.modulate = Color.lightgreen
	else:
		$Sprite.modulate = Color.pink


func process_movement():
	var movement = Vector2()
	movement.x -= Input.get_action_strength("left")
	movement.x += Input.get_action_strength("right")
	movement.y += Input.get_action_strength("down")
	movement.y -= Input.get_action_strength("up")
	# movement = movement.normalized()

	if not red_active:
		if movement.length() > 0:
			position += movement * speed * Manager.frametime
			position = border.clamped(position)
			focused = false

		if Input.is_action_pressed("east"):
			position = $"../East".position
			focused = true
		elif Input.is_action_pressed("south"):
			position = $"../South".position
			focused = true
		elif Input.is_action_pressed("west"):
			position = $"../West".position
			focused = true
		elif Input.is_action_pressed("north"):
			position = $"../North".position
			focused = true
	else:
		if Input.is_action_just_pressed("red"):
			red_trigger_length = (position - target.position).length()
			red_angle = (position - target.position).angle()

		#red_trigger_length += movement.y * speed * Manager.frametime
		red_angle -= movement.x * (speed/(position-target.position).length()) * Manager.frametime

		#if movement.length() > 0:
		#	red_angle = movement.angle()

		position = border.clamped(Vector2(red_trigger_length, 0).rotated(red_angle) + target.position)
		focused = false

	process_green()


func process_green():
	if target:
		$Green.visible = visible_green_indicator
		if Input.is_action_just_pressed("green"):
			position = $Green.global_position
			red_angle += PI
		$Green.global_position = border.clamped(-(position - target.position) + target.position)
	else:
		$Green.visible = false


func fire():
	for i in range(bullet_count):
		var new = bullet.instance()
		add_child(new)
		new.speed = bullet_speed
		new.accel = bullet_accel
		new.rotation = deg2rad(-90)

		var offset = Vector2((bullet_spread / 2) * (float(i)/float((bullet_count-1))*2 - 1),
		-bullet_vertical_offset - pow(i - (bullet_count-1)/2.0, 2) * bullet_arc/pow(bullet_count, 2)).rotated(rotation)

		new.global_position = position + offset
		new.homing_target = target

		var color_lookup = bullet_color_focused if focused else bullet_color_unfocused
		new.modulate = color_lookup[floor(float(i) / bullet_count * color_lookup.size())]
		new.modulate.a = bullet_alpha

		new.potency = bullet_potency
	bullet_timer = bullet_wait


func _on_Stage_beat(strength):
	pass
	#bullet_spread += strength * 100
	#var fpb = 1.0 / $"..".bpm * 60 * Manager.framerate
	#for i in range (fpb):
	#	bullet_spread -= strength * 100/fpb
	#	yield(get_tree(), "idle_frame")

#0	1	 2	  3	   4
#0	125	 250  375  500
#	     500
