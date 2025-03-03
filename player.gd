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
		$Head/Camera.rotate_y(-event.relative.x*.005)

func end_turn() -> void:
	CardDecks.hands[int(name)].addUpCard(CardDecks.withDrawDeck.getUpCard())
	CardDecks.withDrawDeck.deleteUpCard()
	# animations
	#
	$Cards.end_turn()
	#rpc("setUsedDeck",usedDeck)
	pass # Replace with function body.

func start_game():
	$Cards.on_start()
