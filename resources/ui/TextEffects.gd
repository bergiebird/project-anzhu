class_name RichTextTextEffects extends RichTextEffect

var bbcode: String = "fx"


func _process_custom_fx(char_fx :CharFXTransform):
	var brightness_minimum = 1.4 + (0.003 * char_fx.relative_index)
	char_fx.color = brightness_minimum * Lib.Palette.BLUE_WATER_DARK

	var frequency = char_fx.env.get('freq', 20.0)
	var amplitude = char_fx.env.get("amp", 1.0)
	var offset = char_fx.env.get("off", 1.0)

	char_fx.offset.x = amplitude*cos(
		char_fx.elapsed_time * frequency
		+ char_fx.relative_index * offset)
