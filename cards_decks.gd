extends Node3D
class_name Deck
class SimpleDeck:
	var arrayOfCards=[];
	func getCard(ind):
		if(arrayOfCards.size()>ind):
			return arrayOfCards[ind];
		return false;
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
		
