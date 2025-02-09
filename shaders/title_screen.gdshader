shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 5.0) = 10.0; // Velocidade da oscilação
uniform float rotation_strength : hint_range(0.0, 0.05) = 0.02; // Intensidade da rotação
uniform vec2 pivot_point = vec2(0.5, 0.2); // Ponto central da rotação (ajustável)
uniform float wave_strength : hint_range(0.0, 10.0) = 5.0; // Intensidade da distorção
uniform float wave_frequency : hint_range(0.0, 10.0) = 3.0; // Frequência da onda

void fragment() {
    vec2 uv = UV;

    // Criando ondas baseadas no tempo
    float wave = sin(uv.y * wave_frequency + TIME * time_speed) * 0.02;
	// Aplicando deslocamento horizontal
    uv.x += wave * wave_strength;

	// Calcula a direção a partir do ponto central da rotação
    vec2 dir = uv - pivot_point;
    // Calcula um ângulo baseado no tempo e na posição
    float angle = sin(TIME * time_speed) * rotation_strength * length(dir);
    // Calcula os valores do cosseno e seno separadamente
    float cos_angle = cos(angle);
    float sin_angle = sin(angle);

    // Matriz de rotação corrigida
    mat2 rotation_matrix = mat2(vec2(cos_angle, -sin_angle), vec2(sin_angle, cos_angle));

    // Aplica a rotação leve ao UV
    uv = pivot_point + rotation_matrix * dir;

    // Renderiza a textura
    COLOR = texture(TEXTURE, uv);
}