extends AnimatedSprite2D

var floor_tile_meio := ["01", "02", "03"]
var floor_tile_weights := [48, 48, 4]  # 45% para "01", 45% para "02", 10% para "03"
var floor_tile_borda := ["04", "05"]
var floor_tile_quinas := ["06"]

func setup_tile(x: int, y: int, max_x: int, max_y: int) -> void:
	var is_borda = (x == 0 or y == 0 or x == max_x or y == max_y)
	var is_quina = (x == 0 and y == 0) or (x == max_x and y == 0) or (x == 0 and y == max_y) or (x == max_x and y == max_y)
	
	if is_quina:
		play(floor_tile_quinas[0])  # Sempre usa o "05"
		
		# 🔄 Aplica rotação para cada tipo de quina
		if x == max_x and y == 0:   # Quina superior direita (sem rotação)
			rotation_degrees = 0
		elif x == 0 and y == 0:  # Quina superior esquerda (90° para a direita)
			rotation_degrees = -90
		elif x == 0 and y == max_y:  # Quina inferior esquerda (180°)
			rotation_degrees = 180
		elif x == max_x and y == max_y:  # Quina inferior direita (90° para a esquerda)
			rotation_degrees = 90
	
	elif is_borda:
		play(floor_tile_borda[randi() % floor_tile_borda.size()])
		
		# 🔄 Aplica rotação para cada borda
		if x == 0:   # Borda esquerda (90° para a direita)
			rotation_degrees = -90
		elif x == max_x:   # Borda direita (90° para a esquerda)
			rotation_degrees = 90
		elif y == max_y:   # Borda inferior (180°)
			rotation_degrees = 180
		# Bordas superiores não precisam de rotação

	else:
		var randomic = randi_range(0,3)
		match randomic:
			0:
				rotation_degrees = 0
			1:
				rotation_degrees = 90
			2:
				rotation_degrees = 180
			3:
				rotation_degrees = -90
		var tile = get_weighted_random_tile(floor_tile_meio, floor_tile_weights)
		play(tile)  # Tiles do meio não giram
		
func get_weighted_random_tile(tiles: Array, weights: Array) -> String:
	var total_weight = 0
	for w in weights:
		total_weight += w  # Soma total dos pesos
	var random_pick = randi() % total_weight  # Número aleatório até a soma dos pesos
	var cumulative_weight = 0
	for i in range(tiles.size()):
		cumulative_weight += weights[i]
		if random_pick < cumulative_weight:
			return tiles[i]  # Retorna o tile que caiu na faixa

	return tiles[0]  # Fallback (deve ser impossível cair aqui)
