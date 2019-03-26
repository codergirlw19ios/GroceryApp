import Foundation


struct GroceryItem :  Hashable, Decodable, Encodable {
    let name: String
    var cost: Double?    // This should be an optional value
    var quantity: Int
    
    init(_ name: String,  _ quantity: Int = 0, _ cost: Double = 0.0) {
        self.name = name
        self.cost = cost
        self.quantity = quantity
    }
    // must be mutating because structs are value types and you cannot modify struct properties unless mutating
    
    mutating func updateCost(cost: Double) throws
    {
        if (cost > 0.0) {
            self.cost = cost
        } else {
            throw GroceryTripError.costCantBeNegative
        }
        
    }
    mutating func updateQuantity(quantity: Int) throws
    {
        if (quantity > 0) {
            self.quantity = quantity
        } else {
            throw GroceryTripError.quantityCantBeZero
        }
        
    }
}
