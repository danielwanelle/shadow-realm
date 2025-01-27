extends StaticBody2D

var outer_wall := ["01", "02"]

func _ready() -> void:
	var outer_wall_temp = randi() % outer_wall.size()
	$animated_sprite.play(outer_wall[outer_wall_temp])
