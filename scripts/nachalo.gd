extends Node3D

@export var player_scene:PackedScene
@export var port=1027
@export var br=0
@onready var address_entry: LineEdit = $CanvasLayer/PanelContainer/MarginContainer/VBoxContainer/Adress
@onready var start_game_bt: Button = $PanelContainer/MarginContainer/VBoxContainer/StartGame

var peer=ENetMultiplayerPeer.new()
var is_host=false
class multipl extends Node:
	var arr:Array=[-1,-1,-1,-1]
	func add_peer(id,nom):
		arr[nom]=id
		update()
	func get_peer_name(id:int):
		return arr.find(id)
	func get_peer_id(nom:int):
		return arr[nom]
	func update():
		rpc("update_rpc",arr)
	@rpc("authority")
	func update_rpc(dict):
		arr=dict

var multiplayerObj=multipl.new()

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
	var err=peer.create_client(address_entry.text, port)
	multiplayer.multiplayer_peer = peer
	print("joined:",err==OK)

func start_game():
	start_game_bt.disabled=true
	$PanelContainer.visible=false
	CardDecks.make_deck(br)
	$table.opravi_host()
	for i in range(1,br):
		for j in CardDecks.hands[i].arrayOfCards:
			$table.izprati(i,j)
	$table.start()
		
func add_player(id=1):
	var player:=player_scene.instantiate()
	multiplayerObj.add_peer(id,br)
	player.name=str(br)
	br+=1
	#if is_host:
	#print("joined",br,id)
	$table.add_player(player)

func exit_game(id):
	remove_player(id)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _ready() -> void:
	$PanelContainer.visible=false
	multiplayerObj.name="multiplayerThings"
	add_child(multiplayerObj)
	$table.multiplObj=multiplayerObj
#@rpc("any_peer")
#func added_player(nom):
	#if $table.nameN==-1:
		#$table.nameN=nom
