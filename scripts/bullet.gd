extends Area2D

@export var speed: float = 800
@export var damage: int = 30

func _physics_process(delta: float):
	position += transform.x * speed * delta
	
func setup(trans: Transform2D):
	transform = trans
	
func _on_body_entered(body):
	pass
