extends Node3D

var peer=ENetMultiplayerPeer.new()
@export var player_scene:PackedScene
@export var port=1027
@onready var address_entry: LineEdit = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Adress
var is_host=false
func _on_host_button_pressed():
	$CanvasLayer.hide()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	add_player(multiplayer.get_unique_id())
	
	is_host=true
	#upnp_setup()

func _on_join_button_pressed():
	$CanvasLayer.hide()
	
	peer.create_client(address_entry.text, port)
	multiplayer.multiplayer_peer = peer

func add_player(id=1):
	var player=player_scene.instantiate()
	player.name=str(id)
	call_deferred("add_child",player)
func exit_game(id):
	remove_player(id)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
var br=0
func _on_multiplayer_spawner_spawned(_node: Node) -> void:
	if(br==0):
		$Spawn.position.z=-3.659
	print($Spawn.position)
	br+=1;
	pass # Replace with function body.
