extends Node2D

@export var floor_tile: PackedScene
@export var outer_wall_tile : PackedScene

var column := 48
var rows := 32
var space := 16
var grid_position := []

func _ready() -> void:
	if floor_tile == null:
		floor_tile = load("res://scenes/floor_tile.tscn")
	if outer_wall_tile == null:
		outer_wall_tile = load("res://scenes/outer_wall_tile.tscn")
	initialize_list()
	bord_setup()
	
func initialize_list() -> void:
	grid_position.clear()
	for x in column -1:
		for y in rows -1:
			grid_position.append(Vector2(x * space, y * space))

func bord_setup() -> void:
	for x in range(-1, column + 1):
		for y in range(-1, rows + 1):
			var temp = null
			if x == -1 or x == column or y == -1 or y == rows:
				if outer_wall_tile != null:
					temp = outer_wall_tile.instantiate()
				else:
					print("Erro: outer_wall_tile é null!")
			else:
				if floor_tile != null:
					temp = floor_tile.instantiate()
				else:
					print("Erro: floor_tile é null!")
				if temp != null:
					temp.global_position = Vector2(x * space, y * space)
					add_child(temp)			
