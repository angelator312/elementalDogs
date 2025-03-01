extends Node3D

@export var player_scene:PackedScene
@export var port=1027
@export var br=0
@onready var address_entry: LineEdit = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Adress
@onready var start_game_bt: Button = $PanelContainer/MarginContainer/VBoxContainer/StartGame

var peer=ENetMultiplayerPeer.new()
var is_host=false

func _on_host_button_pressed():
	$CanvasLayer.hide()
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	is_host=true
	$PanelContainer.visible=true
	start_game_bt.disabled=false
	add_player(multiplayer.get_unique_id())
	#upnp_setup()

func _on_join_button_pressed():
	$CanvasLayer.hide()
	peer.create_client(address_entry.text, port)
	multiplayer.multiplayer_peer = peer
func start_game():
	CardDecks.make_deck()
	start_game_bt.disabled=true
	$PanelContainer.visible=false
	
func add_player(id=1):
	var player:=player_scene.instantiate()
	player.name=str(id)
	#if is_host:
	print("joined",id)
	br+=1
	call_deferred("add_child",player)
	
func exit_game(id):
	remove_player(id)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
func _on_multiplayer_spawner_spawned(_node: Node) -> void:pass
func _ready() -> void:
	$PanelContainer.visible=false
#@rpc("any_peer")
#func _
