extends Node2D
@onready var nom:int=int($"..".name)
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var anim_player: AnimationPlayer = $"../AnimationPlayer"

@export var width:=720
var played_cards:=0
var mouse_in:=false
var golNaPilnataCarta:=(width/720)*180
var nomPilna:=0
var heightOfCard:=GlobalConfig.get_height_of_card()/2
var poslSizove:Array[Rect2]
var min_width:=GlobalConfig.get_logo_width()
func setNomPilna(newVal:int)->void:
	nomPilna=newVal
	update_variables()
func cardSizes()->Array[Rect2]:
	var sz=CardDecks.hands[nom].size()
	var szs:Array[Rect2]=[]
	var vecSize:=Vector2(min_width,heightOfCard)
	var goliamVecSize:=Vector2(GlobalConfig.get_width_of_card(),heightOfCard)
	var pos:Vector2;
	poslSizove=[]
	for i in range(0,nomPilna):
		pos=positionFromI(i)
		szs.push_back(Rect2(pos,vecSize))
		poslSizove=szs
	pos=positionFromI(nomPilna)
	szs.push_back(Rect2(pos,goliamVecSize))
	poslSizove=szs
	for i in range(nomPilna+1,sz-1):
		pos=positionFromI(i)
		szs.push_back(Rect2(pos,vecSize))
		poslSizove=szs
	if nomPilna!=sz-1:
		pos=positionFromI(sz-1)
		szs.push_back(Rect2(pos,goliamVecSize))
		poslSizove=szs
	return szs
func sizeOfCardContainer() -> Vector2:
	var sum:=Vector2(0,0) 
	for i in poslSizove:
		#print("+",i.size)
		sum+=i.size
	sum.y=heightOfCard
	return sum
func positionToCenter(pos:Vector2,size:Vector2)->Vector2:# От позиция за ляв горен ъгъл става в позиция за център
	var posY=pos.y+size.y/2;
	var posX=pos.x+size.x/2;
	return Vector2(posX,posY)
func positionFromI(i:int)->Vector2:
	var posX=0
	for j in range(0,i):
		posX+=poslSizove[j].size.x
	#posX=posX/2
	#return Vector2(i*GlobalConfig.get_logo_width()+golNaPilnataCarta,get_viewport().size.y-(GlobalConfig.get_height_of_card()/2+40))
	return Vector2(posX,0)
func cardFromX(x:float)->int:
	var sz=CardDecks.hands[nom].size()
	var poslX:float=0.0
	var nowX:float=0.0
	for i in range(0,sz):
		nowX=poslSizove[i].position.x+poslSizove[i].size.x
		if(nowX>=x&&x>=poslX):
			return i
		poslX=nowX
	return sz-1 
func mouse_entered()->void:
	print("mouse_in")
	mouse_in=true
func mouse_exit()->void:
	mouse_in=false
	var sz=CardDecks.hands[nom].size()
	setNomPilna(sz-1)
	drawCards()
func makeCards()->void:
	var sz=CardDecks.hands[nom].size()
	for i in range(0,sz):
		if !get_node_or_null(str(i)):
			var cardName=CardDecks.hands[nom].getCard(i)
			var card=CardDecks.makeAdvancedCard(cardName,i)
			card.name=str(i)
			card.z_index=i+1
			self.add_child(card)
func drawCards()->void:
	var sz=CardDecks.hands[nom].size()
	for i in range(0,sz): 
		var card=get_node(str(i))
		card.position=poslSizove[i].position
func on_new_cards()->void:
	makeCards()
	drawCards()
func update_variables()->void:
	poslSizove=cardSizes()
	min_width=50

func reset_turn_variables()->void:
	played_cards=0

func on_start()->void:
	#$Area2D.mouse_entered.connect(mouse_entered)
	#$Area2D.mouse_exited.connect(mouse_exit)
	
	update_variables()
	var sz=CardDecks.hands[nom].size()
	setNomPilna(sz-1)
	create_polygon(sz-1)
	anim_player.play("start_game")

func end_turn():
	reset_turn_variables()
	update_variables()
	var cardName=CardDecks.hands[nom].getUpCard()
	var sz=CardDecks.hands[nom].size()
	#var card=CardDecks.makeAdvancedCard(cardName,sz-1)
	#card.position=positionFromI(sz-1)+Vector2(mouse_change,0)
	#self.add_child(card) Slow
	create_polygon(sz-1)
	CardDecks.hands[nom].printArr()
	setNomPilna(sz-1)
	on_new_cards()
	anim_player.play("end_turn")
func create_polygon(brCard):
	var sz=sizeOfCardContainer()
	collision_shape_2d.shape.size=sz
	#collision_shape_2d.position=positionToCenter(positionFromI(0),sz)
	if sz.x>0:
		var szV=Vector2(get_viewport().size)
		self.position=sz/2+(szV-sz)/2
		#collision_shape_2d.position=positionToCenter(Vector2.ZERO,get_viewport().size
		#collision_shape_2d.position=positionToCenter(Vector2.ZERO,sz)
		collision_shape_2d.position=Vector2.ZERO
	print(collision_shape_2d.position)
	
func _unhandled_input(event: InputEvent) -> void:
	if mouse_in:
		if event is InputEventMouseMotion:
			update_variables()
			var sz=sizeOfCardContainer()
			print(sz)
			var msX=get_local_mouse_position().x+golNaPilnataCarta
			print("x:",msX)
			var card=cardFromX(msX)
			print("nomPilna:",card)
			setNomPilna(card)
			drawCards()
			#print(nomPilna)
		if event is InputEventMouseButton:
			if event.button_index ==MOUSE_BUTTON_LEFT && event.pressed==true:
				if played_cards<GameConfig.max_cards:
					$"../AnimationPlayer".play("play_card")
					var card=CardDecks.hands[nom].getCard(nomPilna)
					if card:
						var sz=CardDecks.hands[nom].size()
						CardDecks.usedDeck.addUpCard(card)
						CardDecks.hands[nom].deleteCard(nomPilna)
						self.remove_child(get_node(str(nomPilna)))
						for i in range(nomPilna+1,sz):
							var cardN=get_node(str(i))
							cardN.name=str(i-1)
							cardN.z_index=i-1
						setNomPilna(sz-2)
						drawCards()
						played_cards+=1
				#card logic
			
