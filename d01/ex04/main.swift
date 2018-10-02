// let deck = Deck(needShuffle:false)
let deck = Deck(needShuffle:true)
var out:Card?

for _ in 0..<53
{
    out = deck.draw()
    if (out != nil)
    {
        print ("Your draw this:")
        print (out!)

        print ("\nCards in your hand:")
        print (deck.getOuts())

        // print ("Rest of cards in the deck")
        // print(deck)
    }
}

let card1 = Card(c : Color.Spades, v : Value.As)
let card2 = Card(c : Color.Diamonds, v: Value.n2)
print ("\nYou put in the discard deck if the card you draw is already in your hands, in this case YES")
deck.fold(c:card1)
deck.fold(c:card2)
print ("Card in the Discard")
print (deck.getDiscard() + "\n")
