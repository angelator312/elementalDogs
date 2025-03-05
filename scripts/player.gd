extends CharacterBody3D

const SPEED = 300.0
const JUMP_VELOCITY = 10.0 
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var camera: Camera3D = $Head/Camera
var usb=false;
var liiving:=true# Zhiv li e?
var die_way:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationTree.active=true
	camera.current = usb
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if !usb:return
	if event is InputEventMouseMotion:
		$Head/Camera.rotate_y(-event.relative.x*.005)

func end_turn() -> void:
	CardDecks.hands[int(name)].addUpCard(CardDecks.withDrawDeck.getUpCard())
	CardDecks.withDrawDeck.deleteUpCard()
	CardDecks.hands[int(name)].printArr()
	$Cards2D.end_turn()
	#rpc("setUsedDeck",usedDeck)
	pass # Replace with function body.

func start_game():
	$Cards2D.on_start()
