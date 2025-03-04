extends Node2D
@onready var nom:int=int($"..".name)
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var width=720
var mouse_change=0
func positionFromI(i:int)->Vector2:
	return Vector2(i*GlobalConfig.get_logo_width()+(width/720)*180,GlobalConfig.get_height_of_card()/2)
func cardFromX(x:float):
	return (x-(width/720)*180)/GlobalConfig.get_logo_width()
func mouse_entered():
	var card=cardFromX(get_local_mouse_position().x)
	print(card)

func on_start():
	$Area2D.mouse_entered.connect(mouse_entered)
	var sz=CardDecks.hands[nom].size()
	for i in range(0,sz):
		var cardName=CardDecks.hands[nom].getCard(i)
		var card=CardDecks.makeAdvancedCard(cardName,i)
		card.position=positionFromI(i)
		card.name=str(i)
		self.add_child(card)
	create_polygon(sz-1)

func end_turn():
#	tegli animatcia
	var cardName=CardDecks.hands[nom].getUpCard()
	var sz=CardDecks.hands[nom].size()
	var card=CardDecks.makeAdvancedCard(cardName,sz-1)
	card.position=positionFromI(sz-1)+Vector2(mouse_change,0)
	self.add_child(card)
	create_polygon(sz-1)
func create_polygon(brCard,raztegnata:=0):
	collision_shape_2d.shape.size=positionFromI(brCard)+Vector2(GlobalConfig.get_width_of_card(),0)
	collision_shape_2d.position=Vector2(collision_shape_2d.shape.size.x/2+mouse_change,GlobalConfig.get_height_of_card()/2)
	print(collision_shape_2d.shape.size)
	#TODO:Working create polygon and conecting a signals that call the coresponding card's mouse_enter() and mouse_excited()
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			collision_shape_2d.position.x+=GlobalConfig.get_change_on_up_mouse_wheel()
			mouse_change+=GlobalConfig.get_change_on_up_mouse_wheel()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			collision_shape_2d.position.x-=GlobalConfig.get_change_on_up_mouse_wheel()
			mouse_change-=GlobalConfig.get_change_on_up_mouse_wheel()
