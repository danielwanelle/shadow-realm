extends AnimatedSprite2D

var floor_tile_meio := ["01","02"]
#var floor_tile_borda := ["03","04"]

func _ready() -> void:
	play(floor_tile_meio[randi()%floor_tile_meio.size()])
