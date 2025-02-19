extends CharacterBody3D

const SPEED = 300.0
const JUMP_VELOCITY = -320.0 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _enter_tree() -> void:
	$UCharacterBody3D/PauseMenu.hide2()
	set_multiplayer_authority(name.to_int())

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if GlobalVariables.levelWon:
		#animations.play("default")
		#whenWon.visible=true
		#return
	#if(gameOver):
		#if(animations.frame==11):
			##animations.autoplay="death"
			#animations.stop()
			#animations.frame=9
		#return
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY;

		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		#print(di
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	
	#animations.play("run")
	move_and_slide()
