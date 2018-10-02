import Foundation

class Deck : NSObject
{
    static let allSpades:[Card] = Value.allValues.map { Card(c:Color.Spades, v:$0) }    //all spade cards
    static let allDiamonds:[Card] = Value.allValues.map { Card(c:Color.Diamonds, v:$0) }  //all diamond cards
    static let allHearts:[Card] = Value.allValues.map { Card(c:Color.Hearts, v:$0) }    //all heart cards
    static let allClubs:[Card] = Value.allValues.map { Card(c:Color.Clubs, v:$0) }     //all club cards
    static let allCards:[Card] = allSpades + allDiamonds + allHearts + allClubs     //all cards
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