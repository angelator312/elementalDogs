extends Node3D

var peer=ENetMultiplayerPeer.new()
@export var player_scene:PackedScene
func _on_button_pressed() -> void:
	peer.create_server(1027);
	multiplayer.multiplayer_peer=peer;
	multiplayer.peer_connected.connect(add_player)
	add_player()
	$CanvasLayer.hide()

func _on_button_2_pressed() -> void:
	peer.create_client("127.0.0.1",1027);
	multiplayer.multiplayer_peer=peer;
	add_player()
	$CanvasLayer.hide()

func add_player(id=1):
	var player=player_scene.instantiate()
	player.name=str(id)
	call_deferred("add_child",player)
func exit_game(id):
	multiplayer.peer_disconnected.connect(del_player)
	del_player(id)

func del_player(id):
	rpc("_del_player",id)
	
@rpc("any_peer","call_local")
func _del_player(id):
	get_node(str(id)).queue_free()
var br=0
func _on_multiplayer_spawner_spawned(_node: Node) -> void:
	if(br==0):
		$Spawn.position.z=-3.659
	print($Spawn.position)
	br+=1;
	pass # Replace with function body.
