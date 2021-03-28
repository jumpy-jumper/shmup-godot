extends Label

func _process(delta):
	if delta > 0:
		text = str(stepify(1/delta, 1.0))
