shader_type canvas_item;
uniform sampler2D target_texture;
uniform float weight: hint_range(0, 1);

void fragment()
{
    vec4 color_a = texture(TEXTURE, UV);
    vec4 color_b = texture(target_texture, UV);
    COLOR = mix(color_a, color_b, weight);
	
}