extends Node2D
@onready var nom:int=int($"..".name)
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

@export var width=720
var mouse_change=0
var mouse_in:=false
var golNaPilnataCarta=(width/720)*180
var nomPilna:=0
func positionFromI(i:int)->Vector2:
	return Vector2(i*GlobalConfig.get_logo_width()+golNaPilnataCarta,GlobalConfig.get_height_of_card()/2)
func cardFromX(x:float,nomPilna:int):
	var sz=CardDecks.hands[nom].size()
	var malkiFirstChast=nomPilna*GlobalConfig.get_logo_width()
	var goleminaChast=malkiFirstChast+golNaPilnataCarta
	if x>goleminaChast:
		var malkiSecondChast=goleminaChast+(sz-nomPilna-1)*GlobalConfig.get_logo_width()
		if x<malkiSecondChast:
			var cardInd=nomPilna+(x-goleminaChast)/GlobalConfig.get_logo_width()
			return cardInd
	elif x>malkiFirstChast:
		return nomPilna
	elif x<malkiFirstChast:
		return x/GlobalConfig.get_logo_width()
	return -1
func mouse_entered():
	mouse_in=true
func mouse_exit():
	mouse_in=false
	var sz=CardDecks.hands[nom].size()
	nomPilna=sz-1;
	drawCards(nomPilna)
func makeCards():
	var sz=CardDecks.hands[nom].size()
	for i in range(0,sz):
		var cardName=CardDecks.hands[nom].getCard(i)
		var card=CardDecks.makeAdvancedCard(cardName,i)
		if !get_node_or_null(str(i)):
			card.name=str(i)
			self.add_child(card)
func drawCards(pilnaCarta:=-1):
	var sz=CardDecks.hands[nom].size()
	if pilnaCarta==-1:pilnaCarta=sz-1
	for i in range(0,pilnaCarta+1):
		var card=get_node(str(i))
		card.position=positionFromI(i)
	for i in range(pilnaCarta+1,sz):
		var card=get_node(str(i))
		card.position=positionFromI(i)+Vector2(golNaPilnataCarta,0)
func on_start():
	$Area2D.mouse_entered.connect(mouse_entered)
	$Area2D.mouse_exited.connect(mouse_exit)
	var sz=CardDecks.hands[nom].size()
	makeCards()
	drawCards()
	create_polygon(sz-1)
	nomPilna=sz-1

func end_turn():
#	tegli animatcia
	var cardName=CardDecks.hands[nom].getUpCard()
	var sz=CardDecks.hands[nom].size()
	#var card=CardDecks.makeAdvancedCard(cardName,sz-1)
	#card.position=positionFromI(sz-1)+Vector2(mouse_change,0)
	#self.add_child(card)
	create_polygon(sz-1)
	if nomPilna==sz-2:nomPilna=sz-1
	makeCards()
	drawCards(nomPilna)
func create_polygon(brCard,raztegnata:=0):
	collision_shape_2d.shape.size=positionFromI(brCard)+Vector2(GlobalConfig.get_width_of_card(),0)
	collision_shape_2d.position=Vector2(collision_shape_2d.shape.size.x/2+mouse_change,GlobalConfig.get_height_of_card()/2)
	print(collision_shape_2d.shape.size)
	#TODO:Working create polygon and conecting a signals that call the coresponding card's mouse_enter() and mouse_excited()

func _unhandled_input(event: InputEvent) -> void:
	if mouse_in:
		if event is InputEventMouseMotion:
			var card=cardFromX(get_local_mouse_position().x,nomPilna)
			nomPilna=card
			drawCards(nomPilna)
