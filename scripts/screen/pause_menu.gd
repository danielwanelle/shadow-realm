extends CanvasLayer

@onready var quit_btn: TextureButton = $pg_overlay/menu_holder/quit_button2
@onready var resume_btn: TextureButton = $pg_overlay/menu_holder/resume_button
@onready var animator: AnimationPlayer = $animator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		visible = true
		animator.play("pause_game")
		get_tree().paused = true
		resume_btn.grab_focus()
		
func _on_resume_button_pressed() -> void:
	animator.play("resume_game")
	get_tree().paused = false
	await animator.animation_finished
	visible = false


func _on_quit_button_2_pressed() -> void:
	get_tree().quit()
