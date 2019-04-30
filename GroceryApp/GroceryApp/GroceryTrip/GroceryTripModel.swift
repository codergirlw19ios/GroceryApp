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
    init(budget: Double, stateController: StateController, groceryItemPersistence: GroceryItemPersistence, groceryTripModelPersistence: GroceryTripModelPersistence) {
        self.stateController = stateController

        self.groceryItemPersistence = groceryItemPersistence
        cart = groceryItemPersistence.groceryItems()

        self.groceryModelPersistence = groceryTripModelPersistence

        guard let groceryTripModelData = groceryModelPersistence.data() else {
            self.budget = budget
            self.taxRate = 0.0
            persistModel()
            return
        }

        self.budget = groceryTripModelData.budget
        self.taxRate = groceryTripModelData.taxRate
        self.subTotal = groceryTripModelData.subTotal
        self.totalCost = groceryTripModelData.totalCost
        self.balance = groceryTripModelData.balance
    }

    // MARK: - private variables
    private let groceryModelPersistence: GroceryTripModelPersistence
    private let stateController: StateController
    private var shoppingList: [ShoppingListItem] {
        return stateController.shoppingList
    }

    private let groceryItemPersistence: GroceryItemPersistence

    private var cart: [GroceryItem] {
        didSet {
            groceryItemPersistence.write(cart)
        }
    }

    private var budget: Double? {
        didSet { persistModel() }
    }

    private var taxRate: Double{
        didSet { persistModel() }
    }
    private var subTotal: Double {
        get {
            return cart.reduce(0) { accumulatingSubTotal, item in
                return accumulatingSubTotal + ((item.cost ?? 0.00) * Double(item.quantity))
            }
        }
        set { persistModel() }
    }

    private var totalCost: Double {
        get {
            let calculatedTaxRate = taxRate > 0 && taxRate < 1 ? 1 + taxRate : 1

            return subTotal * calculatedTaxRate
        }
        set { persistModel() }

    }
    private var balance: Double {
        get {
            return (budget ?? 0.0) - totalCost
        }
        set { persistModel() }
    }

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
        let shoppingListNames = shoppingList.map{$0.groceryItem.name}

        if overrideShoppingList {

            let groceryItem = GroceryItem(name: name, quantity: quantity, cost: cost)
            cart.append(groceryItem)

        } else {

            guard shoppingListNames.contains(name),
                var groceryListItem = shoppingList.map({ $0.groceryItem
                }).first(where: {$0.name == name})
                else {
                    throw GroceryTripError.itemNotInShoppingList
            }

            guard groceryListItem.quantity == quantity else {
                if groceryListItem.quantity > quantity {
                    throw GroceryTripError.itemQuantityFallsShortOfRequiredAmount
                }
                throw GroceryTripError.itemQuantityExceedsRequiredAmount
            }

            if balance < 0.0 { throw GroceryTripError.exceedsBudget }
            
            updateShoppingListItem(of: groceryListItem, with: cost)
            groceryListItem.update(cost: cost)
            cart.append(groceryListItem)
            delegate?.dataUpdated()
        }
    }

    // update inCart status of the first ShoppingListItem in the shopping cart whose groceryItems match
    func updateShoppingListItem(of groceryItem: GroceryItem, with cost: Double) {
        guard let indexToUpdate: Int = shoppingList.firstIndex(where: { shoppingListItem in
            shoppingListItem.groceryItem == groceryItem }) else { return }

        var temporaryList = shoppingList
        temporaryList[indexToUpdate].updateInCart()
        temporaryList[indexToUpdate].groceryItem.update(cost: cost)

        stateController.shoppingList = temporaryList
    }

    func removeFromCart(_ groceryItem: GroceryItem) {
        cart.removeAll(where: {$0 == groceryItem})

        var matchingShoppingListItem = shoppingList.first { shoppingListItem in
            shoppingListItem.groceryItem == groceryItem }

        matchingShoppingListItem?.updateInCart()
    }

    func checkout() throws -> (shoppingList: [ShoppingListItem], remainingBudget: Double){
        guard taxRate > 0.0 && taxRate < 1 else { throw GroceryTripError.taxRateError }
        guard balance > 0.0 else { throw GroceryTripError.exceedsBudget }
        var remainingShoppingList = shoppingList
        remainingShoppingList.removeAll { $0.inCart == true }

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

    fileprivate func persistModel() {
        guard let budget = budget else { return }

        groceryModelPersistence.write(GroceryTripModelData(budget: budget, taxRate: self.taxRate, subTotal: self.subTotal, totalCost: self.totalCost, balance: self.balance))
    }
}

enum GroceryTripError: Error {
    case exceedsBudget
    case itemNotInShoppingList
    case itemQuantityExceedsRequiredAmount
    case itemQuantityFallsShortOfRequiredAmount
    case taxRateError

    var description: String {
        switch self {
        case .exceedsBudget:
            return "This will exceed your budget."
        case .itemNotInShoppingList:
            return "This is not in your shopping list."
        case .itemQuantityExceedsRequiredAmount:
            return "This quantity is more than on your shopping list."
        case .itemQuantityFallsShortOfRequiredAmount:
            return "This quantity falls short of your shopping list."
        case .taxRateError:
            return "There is a problem with the tax rate."
        }
    }
}

struct GroceryTripModelData: Codable {
    let budget: Double
    let taxRate: Double
    let subTotal: Double
    let totalCost: Double
    let balance: Double
}
