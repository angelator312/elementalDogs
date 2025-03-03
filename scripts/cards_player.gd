extends Node2D
@onready var nom:int=int($"..".name)

@export var width=720

func positionFromI(i:int)->Vector2:
	return Vector2(i*90+(width/720)*180,590)

func on_start():
	var sz=CardDecks.hands[nom].size()
	for i in range(0,sz):
		var cardName=CardDecks.hands[nom].getCard(i)
		var card=CardDecks.makeAdvancedCard(cardName,i)
		card.position=positionFromI(i)
		self.add_child(card)

func end_turn():
#	tegli animatcia
	var cardName=CardDecks.hands[nom].getUpCard()
	var sz=CardDecks.hands[nom].size()
	var card=CardDecks.makeAdvancedCard(cardName,sz-1)
	card.position=positionFromI(sz-1)
	self.add_child(card)
