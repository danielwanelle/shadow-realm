extends CharacterBody2D

# Variáveis de movimento e comportamento
var move_speed := 50.0
var direction := Vector2.ZERO
var life := 10
var is_dead := false
var decision_time := 2.0  # Tempo para mudar o comportamento

# Referências para nós da cena
@onready var player = Globals.get("player")
@onready var anim: AnimatedSprite2D = $anim
@onready var anim_player: AnimationPlayer = $anim_player
@onready var attack_detector: Area2D = $attack_detector
@onready var player_detector: Area2D = $player_detector
@onready var decision_timer: Timer = Timer.new()

func _ready() -> void:
	# Inicializa o timer para mudanças de comportamento
	add_child(decision_timer)
	decision_timer.wait_time = decision_time
	decision_timer.timeout.connect(_change_behavior)
	decision_timer.start()
	
	# Define uma direção inicial aleatória
	change_direction()

func _physics_process(delta):
	if is_dead:
		return
	
	# Aplica a movimentação
	velocity = direction * move_speed
	move_and_slide()

	# Se colidir com uma parede, inverte a direção
	if is_on_wall():
		direction.x *= -1
	if is_on_floor():
		direction.y *= -1

	# Atualiza a animação de movimento
	if velocity.length() > 0:
		anim.play("running")
	else:
		anim.play("idle")

	# Ajusta a direção do sprite usando flip_h no AnimatedSprite2D
	if direction.x < 0:
		anim.flip_h = true
		attack_detector.position.x = -abs(attack_detector.position.x)
		player_detector.position.x = -abs(player_detector.position.x)
	else:
		anim.flip_h = false
		attack_detector.position.x = abs(attack_detector.position.x)
		player_detector.position.x = abs(player_detector.position.x)

func _change_behavior():
	if is_dead:
		return

	# Muda aleatoriamente a direção do movimento
	change_direction()
	decision_timer.wait_time = randf_range(1.0, 3.0)
	decision_timer.start()

func change_direction():
	# Define uma direção aleatória
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	move_speed = 50  # Define uma velocidade padrão

func attack():
	for body in attack_detector.get_overlapping_bodies():
		Globals.set("life", Globals.life - 10)

func _on_player_detector_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	move_speed = 30
	anim_player.play("attack_2")

func _on_player_detector_body_exited(body: Node2D) -> void:
	if is_dead:
		return
	await anim.animation_finished
	move_speed = 100	
	anim.play("running")

func take_damage(amount: int):
	if is_dead:
		return
	life -= amount
	if life <= 0:
		die()
	else:
		damaged()
			
func damaged():
	move_speed = 0
	anim.play("hurt")
	await get_tree().create_timer(0.5).timeout
	anim.play("running")

func die():
	if is_dead:
		return
	is_dead = true
	move_speed = 0
	anim.play("death")
	await get_tree().create_timer(1.5).timeout
	queue_free()
