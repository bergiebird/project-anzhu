shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0);
uniform int width : hint_range(0, 10) = 1;

void fragment() {
    // Calculate the size of a single pixel in UV coordinates
    vec2 unit = TEXTURE_PIXEL_SIZE;
    vec4 sprite_color = texture(TEXTURE, UV);
    
    if (sprite_color.a > 0.0) {
        // If the current pixel is not transparent, show the sprite
        COLOR = sprite_color;
    } else {
        // If current pixel is transparent, check neighbors
        float alpha = 0.0;
        
        // Sample in a cross pattern based on the 'width' integer
        for (int x = -width; x <= width; x++) {
            for (int y = -width; y <= width; y++) {
                // Skip the corners for a rounded "pixel" look, 
                // or remove this 'if' for a blocky square outline
                if (abs(x) + abs(y) > width) continue;
                
                alpha += texture(TEXTURE, UV + vec2(float(x), float(y)) * unit).a;
            }
        }
        
        // If any neighbor has alpha, draw the outline color
        if (alpha > 0.0) {
            COLOR = outline_color;
        } else {
            COLOR = vec4(0.0);
        }
    }
}