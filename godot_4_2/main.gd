extends Node2D

func _ready():
	var x = TestClass.new()._get_int()
	print("Should be 42: ", x)

func _process(delta):
	pass
