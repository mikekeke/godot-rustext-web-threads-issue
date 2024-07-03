extends Node2D

var frames_counter_box = HBoxContainer.new()
var frames_counter_doc = Label.new()
var frames_counter = Label.new()
var main_box = VBoxContainer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Test")
	var fib_res = _FibCalculator._slow_fib(4)
	prints("Fib res: ", fib_res)
	
	frames_counter_doc.text = " (updated every frame via '_process' to see when UI freezes)"
	frames_counter_box.add_child(frames_counter)
	frames_counter_box.add_child(frames_counter_doc)
		
	add_child(main_box)
	main_box.add_child(frames_counter_box)
	_add_sync_ui(main_box)

var frames_cnt = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	frames_cnt +=1
	frames_counter.text = str(frames_cnt)

func _add_sync_ui(parent):
	var container = HBoxContainer.new()
	var input = LineEdit.new()
	input.text = "43"
	var out = Label.new()
	out.text = "(usually 42-45 is big enough to freeze UI)"
	var go_fib_btn = Button.new()
	go_fib_btn.text = "Slow syncronous fib"
	go_fib_btn.pressed.connect(_calc_fib.bind([input, out]))
	
	container.add_child(input)
	container.add_child(go_fib_btn)
	container.add_child(out)
	parent.add_child(container)
	
func _add_threaded_ui(parent):
	pass

func _calc_fib(args):
	var inp = args[0]
	var outp = args[1]
	var inp_text = inp.text
	if !inp_text.is_valid_int():
		outp.text = "Invalid input, need number"
		return
	var res = _FibCalculator._slow_fib(int(inp.text))
	outp.text = str(res)
