import Foundation

struct GroceryItem: Hashable, Decodable {
    let name: String
    var quantity: Int
    var cost: Double?

    init(name: String, quantity: Int, cost: Double? = 0.0) {
        print(#function)
        self.name = name
        self.quantity = quantity
        self.cost = cost
    }

    mutating func update(cost: Double){
        self.cost = cost
    }

    mutating func update(quantity: Int){
        self.quantity = quantity
    }
}
