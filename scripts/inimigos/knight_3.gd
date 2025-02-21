extends CharacterBody2D

var move_speed := 50.0
var direction := Vector2.ZERO  # Agora o movimento acontece nos dois eixos
var life := 10
var is_dead := false
var decision_time := 2.0  # Tempo para mudar o comportamento
var follow_player := false  # Começa sem seguir o player

@onready var player = Globals.get("player")
@onready var sprite: Sprite2D = $sprite
@onready var anim: AnimationPlayer = $anim
@onready var attack_detector: Area2D = $attack_detector
@onready var decision_timer: Timer = Timer.new()
@onready var arrow_instance = preload("res://scenes/inimigos/knight-arrow.tscn")
@onready var spawn_arrow: Marker2D = $player_to_shot/spawnArrow
@onready var player_to_shot: Area2D = $player_to_shot

func _ready() -> void:
	add_child(decision_timer)
	decision_timer.wait_time = decision_time
	decision_timer.timeout.connect(_change_behavior)
	decision_timer.start()

func _physics_process(delta):
	if is_dead:
		return
	# Se o player estiver dentro da área, segue ele
	if follow_player and player:
		direction = (player.global_position - global_position).normalized()
		_rotate_attack_detector()  # Atualiza a posição do attack_detector
	else:
		pass
		direction = direction.normalized()  # Mantém a direção aleatória

	# Se colidir com uma parede, ajusta apenas no eixo necessário
	if is_on_wall():
		direction.x *= -1
	if is_on_floor():
		direction.y *= -1  # Se estiver "grudando" no player por baixo, inverte Y
	# Aplica a movimentação
	velocity = direction * move_speed
	move_and_slide()

func _change_behavior():
	if is_dead or follow_player:
		return  # Se já está morto ou seguindo o player, não muda aleatoriamente
	move_speed = 50
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()  # Movimento aleatório

	# Ajusta a direção do sprite
	if direction.x < 0:
		sprite.scale.x = -1
		
	else:
		sprite.scale.x = 1
	
	# Se colidir com a parede, inverte apenas o eixo dominante
	if is_on_wall():
		if abs(direction.x) > abs(direction.y):  # Se estiver mais inclinado para X
			direction.x *= -1
		else:  # Se estiver mais inclinado para Y
			direction.y *= -1

	decision_timer.wait_time = randf_range(1.0, 3.0)  # Tempo de decisão variável
	decision_timer.start()

func arrow():
	var arrow = arrow_instance.instantiate()  # Instancia a flecha
	get_parent().add_child(arrow)  # Adiciona no mesmo nível do inimigo (não como filho dele)
	
	# Define a posição inicial da flecha
	arrow.global_position = spawn_arrow.global_position  

	# Calcula a direção para o player
	var direction_to_player = (player.global_position - spawn_arrow.global_position).normalized()
	
	# Aplica a rotação ao marcador de spawn da flecha (opcional, apenas para visualização)
	player_to_shot.rotation = direction_to_player.angle()

	# Passa a direção correta para a flecha
	arrow.set_direction(direction_to_player.x, direction_to_player.y)

	# Ajusta a rotação da flecha para apontar na direção certa
	arrow.rotation = direction_to_player.angle()
	
# Quando o player entra na área de detecção, o inimigo começa a segui-lo
func _on_player_to_move_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		follow_player = true
		move_speed = 100
# Quando o player sai da área de detecção, o inimigo volta ao movimento aleatório
func _on_player_to_move_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		follow_player = false
		_change_behavior()  # Força uma nova direção aleatória

func attack():
	for body in attack_detector.get_overlapping_bodies():
		Globals.set("life", Globals.life - 10)

func _rotate_attack_detector():
	if player == null:
		return

	var direction_to_player = (player.global_position - global_position).normalized()
	attack_detector.rotation = direction_to_player.angle()  # Faz o attack_detector girar no eixo do inimigo

	# Mantém o attack_detector a uma distância fixa
	var attack_distance = 10  # Ajuste esse valor para afastar mais ou menos
	attack_detector.position = direction_to_player * attack_distance
	
	# Vira o sprite corretamente no eixo X
	if direction_to_player.x<0:
		sprite.scale.x = -1
	else:
		sprite.scale.x = 1  # Mantém a escala normal para ataques verticais

func _on_player_detector_body_entered(body: Node2D) -> void:
	if is_dead:
		return
	move_speed = 30
	$anim.get_animation("attack_2").loop_mode = Animation.LOOP_LINEAR
	$anim.play("attack_2")

func _on_player_detector_body_exited(body: Node2D) -> void:
	if is_dead:
		return
	$anim.get_animation("attack_2").loop_mode = Animation.LOOP_NONE
	await $anim.animation_finished
	move_speed = 100
	$anim.play("attack_3")

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
	$anim.play("hurt")
	await $anim.animation_finished
	$anim.play("running")
	pass

func die():
	if is_dead:
		return
	is_dead = true
	move_speed = 0
	$anim.play("death")
	await $anim.animation_finished
	call_deferred("drop_itens")
	queue_free()

func _on_player_to_shot_body_entered(body: Node2D) -> void:
	if !follow_player:
		anim.play("attack_3")

func _on_player_to_shot_body_exited(body: Node2D) -> void:
	anim.play("running")

func drop_itens():
	var pocao_vida = preload("res://scenes/itens/pocao_vida.tscn").instantiate()
	get_parent().add_child(pocao_vida)
	pocao_vida.position = position + Vector2(randf_range(-20, 20), 0)
