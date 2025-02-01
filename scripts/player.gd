extends CharacterBody2D

var life = 100; 
var tempo_decrescimo: float = 1.0

const SPEED = 150.0
const SPELL_SCENE = preload("res://scenes/spell.tscn")

var cast  = Vector2.DOWN
var direction  = Vector2.DOWN
var state = ""
var morte = false
var last_direction = Vector2.DOWN  # Guarda a última direção do personagem

@onready var animation := $animated_sprite as AnimatedSprite2D
@onready var spell_position: Marker2D = $Marker2D
@onready var spell_cooldown: Timer = $Timer

func _ready():
	# Inicia o timer para reduzir a vida a cada 3 segundos
	var timer = Timer.new()
	timer.wait_time = tempo_decrescimo
	timer.autostart = true
	timer.connect("timeout", Callable(self, "_reduzir_vida"))
	add_child(timer)

func _reduzir_vida():
	life -= 50
	life = max(life, 0)  # Garante que a vida não fique negativa
	if life == 0:
		morte = true
		state = "morte"

func _physics_process(delta: float) -> void:
	
	$Lifebar.value = life #para manter a barra atualizada
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()
	
	if direction.x and !morte:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction.y and !morte:
		velocity.y = direction.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	cast.x = Input.get_axis("ui_left", "ui_right")
	cast.y = Input.get_axis("ui_up", "ui_down")

	if (cast.x or cast.y) and !morte :
		if spell_cooldown.is_stopped():
			cast_spell(cast.x, cast.y)
	else:
		animation.scale.x = 1
	
	if (direction.x != 0 or direction.y != 0) and !morte:
		last_direction.x = direction.x
		last_direction.y = direction.y
	
	_set_state()
	move_and_slide()

func cast_spell(h_cast, v_cast):
	animation.animation_looped
	var spell_instance = SPELL_SCENE.instantiate()
	spell_instance.set_direction(sign(h_cast), sign(v_cast))
	add_sibling(spell_instance)
	spell_instance.global_position = spell_position.global_position
	spell_cooldown.start()
	
	if cast.x == 1:
		animation.scale.x = -1
		state = "att"
	elif cast.x == -1:
		animation.scale.x = 1
		state = "att"
	else:
		var randi = randf_range(0,1)
		if randi == 1:
			animation.scale.x = -1
			state = "att"
		else:
			state = "att"
		
	if cast.x == 0 and cast.y == 0:
		state = ""

func _set_state():
	var direction_mov = {"move_up": "mov_up",
						"move_down": "mov_down",
						"move_left": "mov_left",
						"move_right": "mov_right"}
	var moving = false
	for action in direction_mov.keys():
		if Input.is_action_pressed(action):
			moving = true
	
	var direction_att = {"ui_up": "att",
						"ui_down": "att",
						"ui_left": "att",
						"ui_right": "att"}
	var attacking = false
	for action in direction_att.keys():
		if Input.is_action_pressed(action):
			attacking = true

	if !moving and !attacking and !morte:
		if last_direction.x > 0:
			state = "right"
		elif last_direction.x < 0:
			state = "left"
		elif last_direction.y > 0:
			state = "down"
		elif last_direction.y < 0:
			state = "up"
	
	if moving and !attacking and !morte:
		if direction.x == 1:
			state = "mov_right"
		elif direction.x == -1:
			state = "mov_left"
		elif direction.y == 1:
			state = "mov_down"
		elif direction.y == -1:
			state = "mov_up"
	
	if Input.is_action_just_pressed("1") == true:
		if last_direction.x > 0:
			animation.scale.x = -1
		else:
			animation.scale.x = 1
		state = "att_sp1"
	elif Input.is_action_just_pressed("2") == true:
		if last_direction.x > 0:
			animation.scale.x = -1
		else:
			animation.scale.x = 1
		state = "att_sp2"
	elif Input.is_action_just_pressed("3") == true:
		if last_direction.x > 0:
			animation.scale.x = -1
		else:
			animation.scale.x = 1
		state = "att_sp3"
	elif Input.is_action_just_pressed("4") == true:
		if last_direction.x > 0:
			animation.scale.x = -1
		else:
			animation.scale.x = 1
		state = "att_sp4"
	elif Input.is_action_just_pressed("5") == true:
		if last_direction.x > 0:
			animation.scale.x = -1
		else:
			animation.scale.x = 1
		state = "att_sp5"
	print(state)
	if animation.animation != state:
		print(state)
		animation.play(state)
