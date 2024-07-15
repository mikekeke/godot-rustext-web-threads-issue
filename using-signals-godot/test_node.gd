extends Node2D

class_name TestNode

signal computation_done(x:int)
var result = null

var thread = Thread.new()

#func _init(x: int):
	#prints("Creating test node: ", x)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var l = Label.new()
	l.text = "TestNode label"
	add_child(l) 
	pass # Replace with function body.

func _start_comp(x: int):
	print("TestNode: start_comp")
	thread.start(_go_cmp.bind(x))
	
func _get_test_str():
	return "1Godot node"
	
func _go_cmp(x: int):
	await get_tree().create_timer(3).timeout
	print("TestNode: Awaited 3 seconds in thread, waiting thread finished")
	thread.wait_to_finish()
	result = x
	print("TestNode: Thread finished")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if result:
		print("TestNode: emitting result")
		computation_done.emit(result)
		result = null
