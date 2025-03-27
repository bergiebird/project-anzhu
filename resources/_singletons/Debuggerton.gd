extends Node #Debuggerton.gd


func enable_print(message:String, debugger_color:String)->void:
	print_rich('[color='+debugger_color+']'+message+' debugging enabled . . .[/color]')

func dprint(message:String, debugger_color:String)->void:
	print_rich('[color='+debugger_color+']'+message+'[/color]')
