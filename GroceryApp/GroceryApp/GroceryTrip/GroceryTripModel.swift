//
//  GroceryTripTableViewCell.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 3/27/19.
//

import Foundation

protocol GroceryTripModelDelegate: class {
    func dataUpdated()
}

class GroceryTripModel {
    // MARK: - Initialization
    init(budget: Double, shoppingList: [GroceryItem], persistence: GroceryItemPersistence) {
        self.budget = budget

        taxRate = 0.0

        let keyValuePairs = Set(shoppingList).map{ ($0, false )}
        self.shoppingList = Dictionary(uniqueKeysWithValues: keyValuePairs)
        print(shoppingList)
        self.persistence = persistence
        cart = persistence.groceryItems()
    }

    // MARK: - private variables
    private var shoppingList: [GroceryItem: Bool]
    private let persistence: GroceryItemPersistence
    private var cart: [GroceryItem] {
        didSet {
            persistence.write(cart)
        }
    }

    private var budget: Double?
    private var taxRate: Double
    private var subTotal: Double {
        return cart.reduce(0) { accumulatingSubTotal, item in
            return accumulatingSubTotal + ((item.cost ?? 0.00) * Double(item.quantity))
        }
    }
    private var totalCost: Double {
        let calculatedTaxRate = taxRate > 0 && taxRate < 1 ? 1 + taxRate : 1

        return subTotal * calculatedTaxRate
    }
    private var balance: Double { return (budget ?? 0.0) - totalCost }

    // MARK: - public variables
    weak var delegate: GroceryTripModelDelegate?
    var budgetText: String? {
        guard let budget = budget else { return nil }
        return Validation.currency(from: budget)
    }
    var taxRateText: String { return Validation.currency(from: taxRate) }
    var subTotalText: String { return Validation.currency(from: subTotal) }
    var totalCostText: String { return Validation.currency(from: totalCost) }
    var balanceText: String { return Validation.currency(from: balance) }
    var listCount: Int { return cart.count }

    // MARK: - public functions

    func cartItemFor(row: Int) -> GroceryItem? {
        guard row < listCount else { return nil }
        return cart[row]
    }

    func addToCart(name: String, quantity: Int, cost: Double, overrideShoppingList: Bool = false) throws {
        let shoppingListNames = shoppingList.keys.map{$0.name}

        if overrideShoppingList {

            let groceryItem = GroceryItem(name: name, quantity: quantity, cost: cost)
            cart.append(groceryItem)

        } else {

            guard shoppingListNames.contains(name),
                var shoppingListItem = shoppingList.keys.first(where: {$0.name == name})
                else {
                    throw GroceryTripError.itemNotInShoppingList
            }

            guard shoppingListItem.quantity == quantity else {
                if shoppingListItem.quantity > quantity {
                    throw GroceryTripError.itemQuantityFallsShortOfRequiredAmount
                }
                throw GroceryTripError.itemQuantityExceedsRequiredAmount
            }

            shoppingList[shoppingListItem] = true
            shoppingListItem.update(cost: cost)
            cart.append(shoppingListItem)
            delegate?.dataUpdated()
        }

        if balance < 0.0 { throw GroceryTripError.exceedsBudget }
    }

    func removeFromCart(_ groceryItem: GroceryItem) {
        cart.removeAll(where: {$0 == groceryItem})
        shoppingList[groceryItem] = false
    }

    func checkout() throws -> (shoppingList: [GroceryItem], remainingBudget: Double){
        guard taxRate > 0.0 && taxRate < 1 else { throw GroceryTripError.taxRateError }
        guard balance > 0.0 else { throw GroceryTripError.exceedsBudget }
        let remainingShoppingList = shoppingList.filter { (shoppingListEntry) -> Bool in
            return !shoppingListEntry.value
            }.keys

        return (Array(remainingShoppingList), balance)
    }

    func update(taxRate: Double) throws {
        try validate(taxRate: taxRate)
        self.taxRate = taxRate
        if balance < 0.0 { throw GroceryTripError.exceedsBudget }
    }

    func update(budget: Double) {
        self.budget = budget
    }

    func validate(name: String?) throws -> String {
        return try Validation.notEmpty(name)
    }

    func validate(quantity: String?) throws -> Int {
        return try Validation.validInt(quantity)
    }

    func validate(cost: String?) throws -> Double {
        return try Validation.validDouble(cost)
    }

    // MARK: - private functions
    fileprivate func validate(taxRate: Double) throws {
        guard taxRate >= 0 && taxRate <= 1.0 else {
            throw GroceryTripError.taxRateError
        }
    }
}

enum GroceryTripError: Error {
    case exceedsBudget
    case itemNotInShoppingList
    case itemQuantityExceedsRequiredAmount
    case itemQuantityFallsShortOfRequiredAmount
    case taxRateError
}
