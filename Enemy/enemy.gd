extends Area2D


signal damage_taken(enemy, amount)


var hp = 0

var act_time = 30

func _process(_delta):
	#position.x += (500 * (-1 if (act_time/60) % 2 == 0 else 1)) * Manager.frametime
	act_time += 1


func _on_Enemy_area_entered(area):
	if area is Bullet:
		hp -= area.potency
		emit_signal("damage_taken", self, area.potency)
		area.queue_free()
