extends Node #Debuggerton.gd
var personal_debug :bool = true

func enable_print(message:String, debugger_color:Color)->void:
	print_rich('[color='+debugger_color.to_html()+']'+message+' debugging enabled . . .[/color]')

func dprint(message:String, debugger_color:Color = Swatchton.BLUE_WATER_LIGHT)->void:
	print_rich('[color='+debugger_color.to_html()+']'+message+'[/color]')

func signal_checker(errors:Array[int], external_debug:bool = false)->void:
	if personal_debug or external_debug:
		for error :int in errors:
			print(error)

func tweener_property_disposal(tweeners :Array[PropertyTweener], external_debug :bool = false)->void:
	if personal_debug or external_debug:
		for tweener :PropertyTweener in tweeners:
			print(tweener)
