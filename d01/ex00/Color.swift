enum Color : String
{
    case Spades = "Your card is of type Spade"
    case Diamonds = "Your card is of type Diamond"
    case Hearts = "Your card is of type Heart"
    case Clubs = "Your card is of type Club"
    static let allColors:[Color] = [.Spades, .Diamonds, .Hearts, .Clubs]
}