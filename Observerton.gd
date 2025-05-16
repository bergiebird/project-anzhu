extends Node #Observerton.gd

## Each scene root contains the signals observer_null, one, two, three. Aka the publisher
## The subscriber is responsible with connecting to their scene root.
## Hold yourself back from using Observerton as a Publisher. That is Signalton's role.

## Use these function calls to connect to the publisher. Ensure to prefix it with parent, grandparent, etc.
#	publisher_null.connect(func(func_name): Observerton.subscribe_null(self, func_name))
#	publisher_one.connect(func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one))
#	publisher_two.connect(func(func_name, one :Variant, two :Variant): Observerton.subscribe_two(self, func_name, one, two))


## These functions
func subscribe_null(target :Object, func_name :String):
	if target.has_method(func_name):
		Callable(target, func_name).call()

func subscribe_one(target :Object, func_name :String, one :Variant):
	if target.has_method(func_name):
		Callable(target, func_name).call(one)

func subscribe_two(target :Object, func_name :String, one :Variant, two :Variant):
	if target.has_method(func_name):
		Callable(target, func_name).call(one, two)

func subscribe_three(target :Object, func_name :String, one :Variant, two :Variant, three :Variant):
	if target.has_method(func_name):
		Callable(target, func_name).call(one, two, three)


## This is for testing purposes, not ready for the field yet.
var lambda_null :Callable = func(func_name): Observerton.subscribe_null(self,func_name)
var lambda_one :Callable = func(func_name, one :Variant): Observerton.subscribe_one(self, func_name, one)
var lambda_two :Callable = func(func_name, one :Variant, two :Variant): Observerton.subscribe_two(self, func_name, one, two)
