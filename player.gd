extends CharacterBody3D

const SPEED = 300.0
const JUMP_VELOCITY = 10.0 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera: Camera3D = $Head/Camera
var usb=false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera.current = usb
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if !usb:return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*.005)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !is_multiplayer_authority():return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("action_jump"):
		velocity.y = JUMP_VELOCITY;
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		#print(di
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	#animations.play("run")
	move_and_slide()




func _on_end_turn_pressed() -> void:
	CardDecks.end_turn();
	#rpc("setUsedDeck",usedDeck)
	pass # Replace with function body.
