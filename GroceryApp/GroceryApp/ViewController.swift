//
//  ViewController.swift
//  GroceryApp
//
//  Created by Amanda Rawls on 2/26/19.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("--> RUN Test Environment <--")
        let hotdogs = GroceryItem(itemName: "Hot dogs", quantity: 1, cost: 2.99)
        let buns = GroceryItem(itemName: "Buns", quantity: 1, cost: 1.79)
        let coffee = GroceryItem(itemName: "Coffee", quantity: 1, cost: 6.99)
        let yogurt = GroceryItem(itemName: "Yogurt", quantity: 5, cost: 1.09)
        let tofu = GroceryItem(itemName: "Tofu", quantity: 2) //, cost: 3.75)
        
        var myShoppingList = [GroceryItem]()
        
        myShoppingList.append(hotdogs)
        myShoppingList.append(buns)
        myShoppingList.append(coffee)
        myShoppingList.append(yogurt)
        myShoppingList.append(tofu)
        
        let schnucks = GroceryTrip(budget: 50.00, arrShoppingList: myShoppingList, taxRate: 0.03)
        
        //schnucks.addToCart(name: hotdogs.itemName, unit: hotdogs.quantity, price: hotdogs.cost!)
        //schnucks.addToCart(name: hotdogs.itemName, unit: hotdogs.quantity, price: hotdogs.cost!)
        //schnucks.addToCart(name: buns.itemName, unit: buns.quantity, price: buns.cost!)
        //schnucks.addToCart(name: coffee.itemName, unit: coffee.quantity, price: coffee.cost!)
        //schnucks.addToCart(name: yogurt.itemName, unit: yogurt.quantity, price: yogurt.cost!)
        //schnucks.addToCart(name: tofu.itemName, unit: tofu.quantity, price: tofu.cost!)
        
        
        do {
            try schnucks.addToCart(name: tofu.itemName, unit: tofu.quantity, price: 3.75)
        } catch {
            print(error)
        }
        
        //schnucks.removeFromCart(item: tofu)
        
        do {
            try print(schnucks.checkout())
        } catch {
            print(error)
        }
    }
}
