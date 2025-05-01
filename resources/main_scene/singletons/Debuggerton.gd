extends Node #Debuggerton.gd


func enable_print(message:String, debugger_color:Color)->bool:
	print_rich('[color='+debugger_color.to_html()+']'+message+' debugging enabled . . .[/color]')
	return true

func dprint(message:String, debugger_color:Color = Swatchton.BLUE_WATER_LIGHT)->void:
	print_rich('[color='+debugger_color.to_html()+']'+message+'[/color]')
