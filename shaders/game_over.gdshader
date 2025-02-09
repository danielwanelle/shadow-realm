shader_type canvas_item;

uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.5; // Intensidade do glitch
uniform float glitch_speed : hint_range(0.1, 5.0) = 1.0; // Velocidade do glitch
uniform float scanline_strength : hint_range(0.0, 1.0) = 0.3; // Intensidade das linhas horizontais piscando
uniform float rgb_shift_amount : hint_range(0.0, 0.02) = 0.005; // Separação de cores RGB

// Define a área do efeito (valores entre 0.0 e 1.0, em relação ao tamanho da textura)
uniform vec2 glitch_area_center = vec2(0.5, 0.5); // Centro da área com glitch
uniform vec2 glitch_area_size = vec2(0.4, 0.2); // Largura e altura do efeito

void fragment() {
    vec2 uv = UV;

    // Verifica se estamos dentro da área do efeito
    vec2 min_bounds = glitch_area_center - glitch_area_size * 0.5;
    vec2 max_bounds = glitch_area_center + glitch_area_size * 0.5;

    bool inside_glitch_area = uv.x >= min_bounds.x && uv.x <= max_bounds.x &&
                              uv.y >= min_bounds.y && uv.y <= max_bounds.y;

    if (inside_glitch_area) {
        // Criando deslocamento aleatório horizontalmente
        float glitch_offset = sin(TIME * glitch_speed + uv.y * 10.0) * 0.02 * glitch_intensity;

        // Pequenas quebras aleatórias nas linhas horizontais
        if (fract(uv.y * 20.0 + TIME * glitch_speed) < 0.2 * glitch_intensity) {
            uv.x += glitch_offset;
        }

        // Simulação de separação RGB dinâmica
        vec4 color_r = texture(TEXTURE, uv + vec2(rgb_shift_amount * sin(TIME * 2.0), 0.0));
        vec4 color_g = texture(TEXTURE, uv);
        vec4 color_b = texture(TEXTURE, uv - vec2(rgb_shift_amount * cos(TIME * 2.0), 0.0));

        // Scanline piscante (linhas horizontais)
        float scanline = sin(uv.y * 300.0 + TIME * 10.0) * scanline_strength;

        // Combinação dos canais de cores para criar efeito glitch dinâmico
        COLOR = vec4(color_r.r, color_g.g, color_b.b, 1.0) + vec4(scanline, scanline, scanline, 0.0);
    } else {
        // Fora da área do glitch, renderiza a textura normal
        COLOR = texture(TEXTURE, uv);
    }
}