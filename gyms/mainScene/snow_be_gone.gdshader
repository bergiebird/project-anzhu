shader_type canvas_item;

uniform float fade_progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 tex = texture(TEXTURE, UV);
    COLOR = tex;
    tex.a *= 1.0 - fade_progress;
}