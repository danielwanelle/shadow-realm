extends Area2D

var spell_speed := 200
var direction := Vector2.ZERO  # Direção do projétil

# Chamado a cada frame, movimenta a flecha
func _process(delta: float) -> void:
	position += direction * spell_speed * delta

# Define a direção e ajusta a rotação da flecha
func set_direction(h_dir, v_dir):
	direction = Vector2(h_dir, v_dir).normalized()  # Normaliza a direção
	rotation = direction.angle()  # Ajusta a rotação da flecha para apontar corretamente
	
func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Se atingir um inimigo
		Globals.set("life", Globals.life - 10)
		queue_free()  # Destroi a flecha ao colidir
