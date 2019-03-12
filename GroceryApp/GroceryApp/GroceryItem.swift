import Foundation

struct GroceryItem : Hashable {
    let name: String
    var quantity: Int
    var cost: Double?

    init(name: String, quantity: Int, cost: Double? = nil) {
        self.name = name
        self.quantity = quantity
        self.cost = cost
    }
    
    init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
        self.cost = nil
    }

    mutating func update(cost: Double){
        self.cost = cost
    }

    mutating func update(quantity: Int){
        self.quantity = quantity
    }
}
