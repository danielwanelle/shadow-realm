extends Area2D

var spell_speed := 500
var horizontal_direction: float
var vertical_direcion: float



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2(horizontal_direction, vertical_direcion) * spell_speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
	
func set_direction(h_dir, v_dir):
	var direction = Vector2(h_dir, v_dir).normalized()  # Normaliza a direção
	horizontal_direction = direction.x
	vertical_direcion = direction.y

	# Ajusta a rotação do projétil de acordo com o ângulo
	rotation = direction.angle() if direction.angle()<1 else direction.angle()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):  # Verifica se o objeto atingido é um inimigo
		body.take_damage(1)  # Chama a função de dano do inimigo
		queue_free()  # Destroi o projétil ao colidir
