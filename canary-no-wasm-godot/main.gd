extends Node2D

var box = GridContainer.new()
var thread = Thread.new()
var frames = Label.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var btn = Button.new()
	btn.text = "Start thread"
	btn.pressed.connect(test_print)
	add_child(box)
	box.add_child(btn)
	box.add_child(frames)

func test_print():
	print("Canary: Starting the thread")
	thread.start(prt)
	print("Canary: Thread ID: ", thread.get_id())

func prt():
	await get_tree().create_timer(3).timeout
	print("Canary: Awaited 3 seconds in thread, waiting thread finished")
	thread.wait_to_finish()
	print("Canary: Thread finished")
	

var cnt = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cnt += 1
	frames.text = str(cnt)
