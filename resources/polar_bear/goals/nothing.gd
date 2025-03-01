extends Node #Nothing
signal start_nothing(name:String)
func enter()->void:
	call_deferred("signall")


func signall()->void:
	start_nothing.emit("Search")
