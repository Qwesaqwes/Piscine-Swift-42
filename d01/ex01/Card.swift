import Foundation

class Card : NSObject
{
	var color:Color
	var value:Value

	init (c:Color, v:Value)
	{
		self.color = c
		self.value = v
	}

	override var description:String
	{
		return "(\(value.hashValue + 1), \(color))"
	}

	override func isEqual(to object: Any?) -> Bool
	{
		if object is Card
		{
			let card = object as! Card
			if (color == card.color && value == card.value)
			{
				return true
			}
		}
		return false
	}

	static func ==(object: Card, object1: Card) -> Bool
	{
		if (object.color == object1.color && object.value == object1.value)
		{
			return true
		}
		return false
	}
}