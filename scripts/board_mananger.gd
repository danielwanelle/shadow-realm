extends Node2D

@export var floor_tile: PackedScene
@export var outer_wall_tile: PackedScene

const COLUMN := 24
const ROWS := 24
const SPACE := 16

var grid_position := []

func _ready() -> void:
	if floor_tile == null:
		floor_tile = load("res://scenes/floor_tile.tscn")
	if outer_wall_tile == null:
		outer_wall_tile = load("res://scenes/outer_wall_tile.tscn")
	
	# Verifica se os tiles foram carregados corretamente
	assert(floor_tile != null, "Erro: floor_tile não foi carregado!")
	assert(outer_wall_tile != null, "Erro: outer_wall_tile não foi carregado!")
	
	initialize_list()
	board_setup()

# Inicializa a lista de posições do grid
func initialize_list() -> void:
	grid_position.clear()
	for x in range(COLUMN - 1):
		for y in range(ROWS - 1):
			grid_position.append(Vector2(x * SPACE, y * SPACE))

# Configura o tabuleiro com tiles de chão e paredes externas
func board_setup() -> void:
	for x in range(-1, COLUMN + 1):
		for y in range(-1, ROWS + 1):
			var tile_instance = null
			
			# Decide qual tile instanciar
			if x == -1 or x == COLUMN or y == -1 or y == ROWS:
				tile_instance = outer_wall_tile.instantiate() if outer_wall_tile else null

				# 🔄 Chama a função setup_wall_tile para configurar corretamente
				if tile_instance and tile_instance.has_method("setup_wall_tile"):
					tile_instance.setup_wall_tile(x + 1, y + 1, COLUMN+1, ROWS+1)  # Ajuste para compensar os índices

			else:
				tile_instance = floor_tile.instantiate() if floor_tile else null

				# 🔄 Chama a função setup_tile para configurar corretamente os tiles do chão
				if tile_instance and tile_instance.has_method("setup_tile"):
					tile_instance.setup_tile(x, y, COLUMN - 1, ROWS - 1)

			# Adiciona o tile à cena
			if tile_instance:
				tile_instance.global_position = Vector2(x * SPACE, y * SPACE)
				add_child(tile_instance)
			else:
				print("Erro: Não foi possível instanciar o tile em (", x, ",", y, ")")
