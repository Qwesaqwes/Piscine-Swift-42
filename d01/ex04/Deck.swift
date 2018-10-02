import Foundation

class Deck : NSObject
{
	static let allSpades:[Card] = Value.allValues.map { Card(c:Color.Spades, v:$0) }    //all spade cards
	static let allDiamonds:[Card] = Value.allValues.map { Card(c:Color.Diamonds, v:$0) }  //all diamond cards
	static let allHearts:[Card] = Value.allValues.map { Card(c:Color.Hearts, v:$0) }    //all heart cards
	static let allClubs:[Card] = Value.allValues.map { Card(c:Color.Clubs, v:$0) }     //all club cards
	static let allCards:[Card] = allSpades + allDiamonds + allHearts + allClubs     //all cards

	var cards:[Card] = allCards
	var discards:[Card] = []
	var outs:[Card] = []

	init (needShuffle:Bool)
	{
		if (needShuffle)
		{
			cards = cards.shuffle()
		}
	}

	override var description:String
	{
		var cardDeck:String = ""
		for card in cards
		{
			cardDeck = cardDeck + card.description + "\n"
		}
		return cardDeck
	}

	func draw() -> Card?
	{
		if (cards.count >= 1)
		{
			outs.append(cards.first!)
			cards.removeFirst()
			return (outs.last)
		}
		else
		{
			print ("No more Card to draw from Deck")            
		}
		return nil
	}

	func fold(c:Card) -> Void
	{
		if (outs.count > 0)
		{
			for out in outs
			{
				if (out == c)
				{
					if let itemToRemoveIndex = outs.index(of:out)
					{
						discards.append(c)
						outs.remove(at:itemToRemoveIndex)
					}
				}
			}
		}
	}

	func getOuts() -> String
	{
		var cardDeck:String = ""
		for card in outs
		{
			cardDeck = cardDeck + card.description + "\n"
		}
		return cardDeck
	}

	func getDiscard() -> String
	{
		var cardDeck:String = ""
		for card in discards
		{
			cardDeck = cardDeck + card.description + "\n"
		}
		return cardDeck
	}
}

extension Array
	{
		func shuffle() -> [Card]
		{
			var shuffledDeck:[Card] = []
			var tmpDeck = Deck.allCards
			for _ in tmpDeck
			{
				let j = Int(arc4random_uniform(UInt32(tmpDeck.count)))
				shuffledDeck.append(tmpDeck[j])
				tmpDeck.remove(at:j)
			}
			return shuffledDeck
		}
	}