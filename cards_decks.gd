extends Node3D
class_name Deck

var cardFromName:={
	"not":
		{
			"name":"not",
			"explosive":false,
			"powerful":0,
			"on_play":func():pass,
			"on_get":func():pass,
			"special_card":true, # true - predi razdavaneto se slaga, false - sled razdavane se slaga 
			"times":2
		}
}

class SimpleDeck:
	var arrayOfCards;
	func _init(cards) -> void:
		arrayOfCards=cards
	func getCard(ind):
		if(arrayOfCards.size()>ind):
			return arrayOfCards[ind];
		return false;
	func getUpCard():
		return arrayOfCards.back()
	func shuffle():
		arrayOfCards.shuffle()
	func addCard(ind,card):
		if(arrayOfCards.size()>ind):
			return arrayOfCards.insert(ind,card);
		return false;
	func addUpCard(card): #Otgore
		arrayOfCards.push_back(card)
	func deleteCard(ind):
		if(arrayOfCards.size()>ind):
			arrayOfCards.pop_at(ind)
	func deleteUpCard():
		arrayOfCards.pop_back()
	func size():
		return arrayOfCards.size()
class MyDeck extends SimpleDeck:
	func play_card(card_index):
		var stop_card=func():pass
	func endTurn(withDrawDeck:SimpleDeck): #Otgore
		var card=withDrawDeck.getUpCard()
		arrayOfCards.push_back(card)


var cards :=cardFromName.values()
var usedDeck:=SimpleDeck.new([])
var withDrawDeck:=SimpleDeck.new([]);

func deletUpCardOfUsed():
	usedDeck.deleteUpCard_rpc()
	rpc("deletUpCardOfUsed_rpc")

@rpc("any_peer","call_local","reliable",1)
func deletUpCardOfUsed_rpc():
	usedDeck.deleteUpCard()

func addUpCardOfUsed(card_name):
	addUpCardOfUsed_rpc(card_name)
	rpc("addUpCardOfUsed_rpc",card_name)
@rpc("any_peer","call_remote","reliable",1)
func addUpCardOfUsed_rpc(card_name):
	print(card_name)
	usedDeck.addUpCard(card_name)
func addUpCardOfWithDraw(card_name,ind):
	addUpCardOfWithDraw_rpc(card_name,ind)
	rpc("addUpCardOfWithDraw_rpc",card_name,ind)
@rpc("any_peer","call_remote","reliable",1)
func addUpCardOfWithDraw_rpc(card_name,ind):
	#print(card_name)
	withDrawDeck.addUpCard(card_name)
	var cardNow=makeAdvancedCard(card_name,ind)
	#get_node("/root/Main/WithDrawDeck").add_child(cardNow)
func makeAdvancedCard(card_name,ind):
	print(card_name)
	var cardNow=Card.new(ind);
	cardNow.explosive=cardFromName[card_name]["explosive"]
	cardNow.name_of_card=cardFromName[card_name]["name"]
	cardNow.powerful=cardFromName[card_name]["powerful"]
	cardNow.on_play=cardFromName[card_name]["on_play"]
	cardNow.on_get=cardFromName[card_name]["on_get"]
	return cardNow;
func end_turn():
	pass
func make_deck():
	var withDrawDeck2=SimpleDeck.new([])
	for i in range(0,cards.size()):
		for j in range(0,cards[i].times):
			withDrawDeck2.addUpCard(cards[i])
	withDrawDeck2.shuffle()
	#print(withDrawDeck2.arrayOfCards)
	for i in range(0,withDrawDeck2.size()):
		addUpCardOfWithDraw(withDrawDeck2.getCard(i).name,i)
	print(withDrawDeck.arrayOfCards)
