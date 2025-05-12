extends Node #Observerton.gd

func match_null(target :Object, func_name :String):
	if target.has_method(func_name):
		Callable(target, func_name).call()

func match_one(target :Object, func_name :String, one :Variant):
	if target.has_method(func_name):
		Callable(target, func_name).call(one)

func match_two(target :Object, func_name :String, one :Variant, two :Variant):
	if target.has_method(func_name):
		Callable(target, func_name).call(one, two)

#	observer_null.connect(func(func_name): Observerton.match_null(self, func_name))
#	observer_one.connect(func(func_name, one :Variant): Observerton.match_one(self, func_name, one))
#	observer_two.connect(func(func_name, one :Variant, two :Variant): Observerton.match_two(self, func_name, one, two))
