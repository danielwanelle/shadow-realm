extends CharacterBody2D

const SPEED = 300.0

@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@onready var bullet_spawn_pos: Node2D = $Polygon2D/Node2D

func _physics_process(delta: float) -> void:
	var horizontal_direction := Input.get_axis("move_left", "move_right")
	var vertical_direction := Input.get_axis("move_up", "move_down")

	if horizontal_direction:
		velocity.x = horizontal_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	var horizontal_shot := Input.get_axis("ui_left", "ui_right")
	var vertical_shot := Input.get_axis("ui_up", "ui_down")

	#if horizontal_shot:
		#velocity.x = horizontal_shot * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		
func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.setup(bullet_spawn_pos.global_transform)
	get_tree().root.add_child(bullet)
	
	

	move_and_slide()
