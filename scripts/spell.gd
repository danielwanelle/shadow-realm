extends Area2D

var spell_speed := 500
var horizontal_direction: float
var vertical_direcion: float 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += spell_speed * horizontal_direction * delta
	position.y += spell_speed * vertical_direcion * delta


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	
func set_direction(h_dir, v_dir):
	horizontal_direction = h_dir
	vertical_direcion = v_dir
