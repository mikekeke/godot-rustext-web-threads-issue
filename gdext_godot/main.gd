extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var x = TestClass.new()._get_int()
	print("Should be 42: ", x)
