extends CharacterBody2D

var tempo_decrescimo: float = 1.0

const SPEED = 150.0
const SPELL_SCENE = preload("res://scenes/player/spell.tscn")

var cast  = Vector2.DOWN
var direction  = Vector2.DOWN
var life = Globals.get("life")
var state = ""
var morte = false
var last_direction = Vector2.DOWN  # Guarda a última direção do personagem
var contador_de_moeda: int = 0

@onready var animation := $animated_sprite as AnimatedSprite2D
@onready var spell_position: Marker2D = $Marker2D
@onready var spell_cooldown: Timer = $Timer
@onready var hud: Label = $"../Hud/Moeda"

func _ready():
	Globals.set("player", self)
	# Conecta o sinal animation_finished do AnimatedSprite2D
	animation.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _physics_process(delta: float) -> void:
	if Globals.get("life") == 0:
		morte = true
	if life != null and life > Globals.get("life") and !morte:
		animation.play("damaged")
		await animation.animation_finished
		life = Globals.get("life")
	if $Lifebar != null and $Lifebar.value != null and Globals.life != null: 
		$Lifebar.value = Globals.life #para manter a barra atualizada
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()
	
	cast.x = Input.get_axis("ui_left", "ui_right")
	cast.y = Input.get_axis("ui_up", "ui_down")
	
	if !morte:
		if direction.x:
			velocity.x = direction.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		if direction.y:
			velocity.y = direction.y * SPEED
		else:
			velocity.y = move_toward(velocity.y, 0, SPEED)

		if (cast.x or cast.y):
			if spell_cooldown.is_stopped():
				cast_spell(cast.x, cast.y)
		else:
			animation.scale.x = 1
		
		if (direction.x != 0 or direction.y != 0):
			last_direction.x = direction.x
			last_direction.y = direction.y
		_set_state()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		animation.scale.x = 1
		state = "morte"
		if animation.animation != state:
			animation.play(state)
		
	move_and_slide()

func cast_spell(h_cast, v_cast):	
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
	elif cast.y == 1:
		animation.scale.x = -1
		state = "att"
	else:
		animation.scale.x = -1
		state = "att"
		
	if cast.x == 0 and cast.y == 0:
		animation.scale.x = 1
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

	if !moving and !attacking:
		if last_direction.x > 0:
			state = "right"
		elif last_direction.x < 0:
			state = "left"
		elif last_direction.y > 0:
			state = "down"
		elif last_direction.y < 0:
			state = "up"
	
	if moving and !attacking:
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
	if animation.animation != state:
		animation.play(state)
	
func _on_animation_finished() -> void:
	# Se você precisar saber qual animação acabou, pode verificar a propriedade "animation":
	if animation.animation == "morte":
		get_tree().change_scene_to_file("res://scenes/Screens/game_over.tscn")

func coletar_moeda():
	contador_de_moeda += 1
	hud.text = "Moedas: %d" % contador_de_moeda

func aumentar_vida():
	Globals.set("life", Globals.life + 50)
