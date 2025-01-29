extends StaticBody2D

var outer_walls_cima := ["01a", "01b", "01c", "01d", "01e"]  # Verifique se tem 8 variações na animação do Godot
var outer_walls_weights := [60, 10, 10, 10, 10]
var outer_walls_lados := ["02"]
var outer_walls_baixo := ["03"]
var outer_walls_quina := ["04"]

func setup_wall_tile(x: int, y: int, max_x: int, max_y: int) -> void:
	var animated_sprite = $animated_sprite  # Pegamos o nó correto
	
	var is_cima = (y == 0 and x >= 0 and x <= max_x)
	var is_baixo = (y == max_y and x > 0 and x < max_x)
	var is_lado_esquerdo = (x == 0 and y > 0 and y < max_y)
	var is_lado_direito = (x == max_x and y > 0 and y < max_y)
	var is_quina = (x == 0 and y == max_y) or (x == max_x and y == max_y)
	
	if is_quina:
		animated_sprite.play(outer_walls_quina[0])  # Sempre usa "04" para quinas
		
		# 🔄 Aplica rotação para cada quina
		if x == max_x and y == 0:  # Quina superior direita (sem rotação)
			animated_sprite.rotation_degrees = 0
		elif x == 0 and y == 0:  # Quina superior esquerda (90°)
			animated_sprite.rotation_degrees = 90
		elif x == 0 and y == max_y:  # Quina inferior esquerda (180°)
			animated_sprite.flip_h = true
	
	elif is_cima:
		var tile = get_weighted_random_wall_tile(outer_walls_cima, outer_walls_weights)
		animated_sprite.play(tile)  # 🔄 Escolhe um item aleatório
	
	elif is_baixo:
		animated_sprite.play(outer_walls_baixo[0])  # Usa "03" para a parte inferior
	
	elif is_lado_esquerdo:
		animated_sprite.play(outer_walls_lados[0])  # Usa "02" para os lados
		animated_sprite.rotation_degrees = 180  # Esquerda gira 180°
	
	elif is_lado_direito:
		animated_sprite.play(outer_walls_lados[0])  # Usa "02" para os lados (Direita não gira)
	
	print("Parede em (", x, ",", y, ") é", " QUINA" if is_quina else " CIMA" if is_cima else " BAIXO" if is_baixo else " LADO", " - Rotação:", animated_sprite.rotation_degrees)
	
func get_weighted_random_wall_tile(tiles: Array, weights: Array) -> String:
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
