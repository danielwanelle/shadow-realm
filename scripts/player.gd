extends CharacterBody2D

const SPEED = 300.0
const SPELL_SCENE = preload("res://scenes/spell.tscn")

@onready var spell_position: Marker2D = $Marker2D
@onready var spell_cooldown: Timer = $Timer

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
		
	var horizontal_cast := Input.get_axis("ui_left", "ui_right")
	var vertical_cast := Input.get_axis("ui_up", "ui_down")

	if horizontal_cast or vertical_cast:
		if spell_cooldown.is_stopped():
			cast_spell(horizontal_cast, vertical_cast)
		
	move_and_slide()

func cast_spell(h_cast, v_cast):
	var spell_instance = SPELL_SCENE.instantiate()
	spell_instance.set_direction(sign(h_cast), sign(v_cast))
	add_sibling(spell_instance)
	spell_instance.global_position = spell_position.global_position
	spell_cooldown.start()
