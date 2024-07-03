extends Node2D

var frames_counter = Label.new()
var main_box = VBoxContainer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Test")
	var fib_res = _FibCalculator._slow_fib(4)
	prints("Fib res: ", fib_res)
	
	add_child(main_box)
	main_box.add_child(frames_counter)
	_add_sync_ui(main_box)

var frames_cnt = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frames_cnt +=1
	frames_counter.text = str(frames_cnt)


func _add_sync_ui(parent):
	var container = HBoxContainer.new()
	var input = LineEdit.new()
	var out = Label.new()
	var go_fib_btn = Button.new()
	go_fib_btn.text = "Sync fib"
	go_fib_btn.pressed.connect(_calc_fib.bind([input, out]))
	
	container.add_child(input)
	container.add_child(go_fib_btn)
	container.add_child(out)
	parent.add_child(container)
	
	#add_child(set_seed_btn)


func _calc_fib(args):
	var js = JavaScriptBridge.create_object("Object")
	prints("js: ", js)
	js.ff = 1

	
	var inp = args[0]
	var outp = args[1]
	var inp_text = inp.text
	if !inp_text.is_valid_int():
		outp.text = "Invalid input, need number"
		return
	var res = _FibCalculator._slow_fib(int(inp.text))
	outp.text = str(res)
