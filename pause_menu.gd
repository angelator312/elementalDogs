extends Control
var show0=false;

func show2():
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE
	$".".show()
	show0=true
	Engine.time_scale=0

func hide2():
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	$".".hide()
	show0=false
	Engine.time_scale=1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".hide()
	show0=false
	pass # Replace with function body.
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("quit")&&!show0):
		self.show2()
	elif (event.is_action_pressed("quit")&&show0):
		self.hide2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_resume_pressed() -> void:
	hide2()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	$"../".exit_game(name.to_int())
	pass # Replace with function body.
