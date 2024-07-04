extends Node2D

var frames_counter_box = HBoxContainer.new()
var frames_counter_doc = Label.new()
var frames_counter = Label.new()
var main_box = VBoxContainer.new()

var thread: Thread
signal on_calc_completed(res: String)

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
	_add_threaded_ui(main_box)

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
	var container = HBoxContainer.new()
	var input = LineEdit.new()
	input.text = "43"
	var out = Label.new()
	out.text = "(usually 42-45 is big enough to freeze UI)"
	var go_fib_btn = Button.new()
	go_fib_btn.text = "Slow in-thread fib"
	go_fib_btn.pressed.connect(_calc_fib_in_thread.bind(input))
	
	container.add_child(input)
	container.add_child(go_fib_btn)
	container.add_child(out)
	parent.add_child(container)
	on_calc_completed.connect(func (n): out.text = n)
	
func _calc_fib_in_thread(inp: LineEdit):
	prints("_calc_fib_in_thread for ", inp.text)
	if !thread:
		print("NEW thread _calc_fib_in_thread")
		thread = Thread.new()
	if thread.is_alive():
		print("Thread already running. Pls wait")
		return
	thread.start(_calc_fib_threaded.bind(inp.text))

func _calc_fib(args):
	var inp = args[0]
	var outp = args[1]
	var inp_text = inp.text
	if !inp_text.is_valid_int():
		outp.text = "Invalid input, need number"
		return
	var res = _FibCalculator._slow_fib(int(inp.text))
	prints("_calc_fib res: ", res)
	outp.text = str(res)
	

func _calc_fib_threaded(n: String):
	var res: String
	if !n.is_valid_int():
		res = "Invalid input, need number"
	else:
		res = str(_FibCalculator._slow_fib(int(n)))
	prints("_calc_fib_threaded res: ", res)
	call_deferred("emit_signal", "on_calc_completed", res)
