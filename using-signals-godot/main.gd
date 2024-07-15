extends Node2D

var frames_counter_box = HBoxContainer.new()
var frames_counter_doc = Label.new()
var frames_counter = Label.new()
var main_box = VBoxContainer.new()

var test_node = _RustTestNode.new()

const timing_hint = "(usually 40-45 is big enough to noticeably freeze UI)"
const default_fib_arg = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Test")
	add_child(test_node) # seems like w/o it version with signal and Rust thread won't work!
	# This signal callback also works as expected if enabled
	var test_enabled = false
	if test_enabled:
		test_node.computation_done.connect(func (res): prints("Godot: Signal received: ", res))
	
	var check_res = test_node._get_test_str()
	prints("Rust check: ", check_res)

	_add_sync_ui(main_box)
	_add_threaded_ui(main_box)
	_set_frames_counter_ui(main_box)
	
	add_child(main_box)

var frames_cnt = 0
func _process(delta):
	frames_cnt +=1
	frames_counter.text = str(frames_cnt)

func _set_frames_counter_ui(main_box):
	frames_counter_doc.text = " (updated every frame via '_process' to see when UI freezes)"
	frames_counter_box.add_child(frames_counter)
	frames_counter_box.add_child(frames_counter_doc)
	main_box.add_child(frames_counter_box)

func _add_sync_ui(parent):
	var container = HBoxContainer.new()
	var input = LineEdit.new()
	input.text = str(default_fib_arg)
	var out = Label.new()
	out.text = timing_hint
	var go_fib_btn = Button.new()
	go_fib_btn.text = "Slow synchronous fib"
	go_fib_btn.pressed.connect(_calc_fib.bind([input, out]))
	
	container.add_child(input)
	container.add_child(go_fib_btn)
	container.add_child(out)
	parent.add_child(container)
	
func _add_threaded_ui(parent):
	var container = HBoxContainer.new()
	var input = LineEdit.new()
	input.text = str(default_fib_arg)
	var out = Label.new()
	out.text = timing_hint
	var go_fib_btn = Button.new()
	go_fib_btn.text = "Slow in-thread fib"
	go_fib_btn.pressed.connect(_calc_fib_in_rust_thread.bind([input, out]))
	
	container.add_child(input)
	container.add_child(go_fib_btn)
	container.add_child(out)
	parent.add_child(container)
	
func _calc_fib_in_rust_thread(args):
	var inp = args[0]
	var outp = args[1]
	var n = inp.text
	if !n.is_valid_int():
		outp.text = "Invalid input, need number"
		return
	
	test_node._async_fib(int(n))
	var result = await test_node.computation_done
	outp.text = result

func _calc_fib(args):
	var inp = args[0]
	var outp = args[1]
	var n = inp.text
	if !n.is_valid_int():
		outp.text = "Invalid input, need number"
		return
	var result = test_node._sync_fib(int(n))
	outp.text = result
