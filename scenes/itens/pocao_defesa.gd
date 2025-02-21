extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.ativar_escudo();
		coletado()

func coletado():
	queue_free()
