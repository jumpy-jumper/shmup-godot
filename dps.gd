extends Label

var total = 0
var act_time = 0

func _process(delta):
	act_time += 1
	text = str(total) + "\n" + str(stepify(float(total) / float(act_time) * Manager.framerate, 1))


func _on_Enemy_damage_taken(enemy, amount):
	total += amount
