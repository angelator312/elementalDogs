extends Node3D
class_name Deck

var cardFromName:={
	"Nope":
		{
			"name":"Nope",
			"explosive":false,
			"powerful":1,
			"on_play":func():pass,
			"on_get":func():pass,
			"special_card":false, #  false - predi razdavaneto se slaga, true - sled razdavane se slaga
			"times":5
		},
	"Shuffle":
		{
			"name":"Shuffle",
			"explosive":false,
			"powerful":0,
			"on_play":func():pass,
			"on_get":func():pass,
			"special_card":false, # 
			"times":4
		},
	"Attack":
		{
			"name":"Attack",
			"explosive":false,
			"powerful":1,
			"on_play":func():pass,
			"on_get":func():pass,
			"special_card":false, # 
			"times":4
		},
	"Skip":
		{
			"name":"Skip",
			"explosive":false,
			"powerful":2,
			"on_play":func():pass,
			"on_get":func():pass,
			"special_card":false, # 
			"times":4
		},
	"Favor":
		{
			"name":"Favor",
			"explosive":false,
			"powerful":0,
			"on_play":func():pass,
			"on_get":func():pass,
			"special_card":false, # 
			"times":4
		},
	"Exploding":
		{
			"name":"Exploding",
			"explosive":true,
			"powerful":2,
			"on_play":func():pass,
			"on_get":func():pass,
			"special_card":true, # 
			"times":4
		},
	

}

class SimpleDeck extends Node:
	var replicated=false
	var arrayOfCards;
	func _init(cards:=[],replicate:=false) -> void:
		arrayOfCards=cards
		replicated=replicate
	func getCard(ind:int):
		if(arrayOfCards.size()>ind&& ind>-1):
			return arrayOfCards[ind];
		return false;
	func getUpCard():
		return arrayOfCards.back()
	func shuffle():
		arrayOfCards.shuffle()
		update()
	func addCard(ind:int,card):
		if(arrayOfCards.size()>ind):
			var a=arrayOfCards.insert(ind,card);
			update()
			return a; 
		return false;
	func addUpCard(card): #Otgore
		arrayOfCards.push_back(card)
		update()
	func deleteCard(ind:int):
		if(arrayOfCards.size()>ind):
			arrayOfCards.pop_at(ind)
			update()
	func deleteUpCard():
		arrayOfCards.pop_back()
		update()
	func size():
		return arrayOfCards.size()
	func printArr():
		print(arrayOfCards)
	func update():
		if replicated:
			rpc("update_rpc",arrayOfCards)
	@rpc("any_peer","call_remote","reliable",1)
	func update_rpc(arr):
		arrayOfCards=arr

class PlayerHand extends SimpleDeck:
	func play_card(card_index:int):
		var card=getCard(card_index)
		deleteCard(card_index)
		#Todo: Pravim on_play 
	func endTurn(withDrawDeck:SimpleDeck): #Otgore
		var card=withDrawDeck.getUpCard()
		arrayOfCards.push_back(card)
		withDrawDeck.deleteUpCard()

var cards :=cardFromName.values()
var usedDeck:=SimpleDeck.new([],true)
var withDrawDeck:=SimpleDeck.new([],true);
var hands=[PlayerHand.new(),PlayerHand.new(),PlayerHand.new(),PlayerHand.new()]
func _init() -> void:
	add_child(usedDeck)
	add_child(withDrawDeck)
func makeAdvancedCard(card_name,ind):
	#print(card_name)
	var cardNow=Card.new(ind);
	cardNow.explosive=cardFromName[card_name]["explosive"]
	cardNow.name_of_card=cardFromName[card_name]["name"]
	cardNow.powerful=cardFromName[card_name]["powerful"]
	cardNow.on_play=cardFromName[card_name]["on_play"]
	cardNow.on_get=cardFromName[card_name]["on_get"]
	return cardNow;

func make_deck(brPlayers):
	for i in range(0,CardDecks.cards.size()):
		if !CardDecks.cards[i].special_card:
			for j in range(0,CardDecks.cards[i].times):
				#print_t
				withDrawDeck.addUpCard(CardDecks.cards[i].name)
	withDrawDeck.shuffle()
	
	razdai(brPlayers)
	
	for i in range(0,CardDecks.cards.size()):
		if CardDecks.cards[i].special_card:
			for j in range(0,CardDecks.cards[i].times):
				#print_t
				withDrawDeck.addUpCard(CardDecks.cards[i].name)
	withDrawDeck.shuffle()
	withDrawDeck.printArr()
func razdai(br):
	for plId in range(0,br):
		hands.push_back(PlayerHand.new([]))
		for i in range(0,4):
			hands[plId].addUpCard(withDrawDeck.getUpCard())
			withDrawDeck.deleteUpCard()
		print(hands[plId].arrayOfCards)
	print(withDrawDeck.arrayOfCards)
	pass
@rpc()
func razdai_rpc():
	pass
