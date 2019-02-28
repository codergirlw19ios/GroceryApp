## Swift Review Problem
You are going to write a GroceryTrip class that will serve as a data model for a grocery shopping app. The model will be instantiated for each grocery shopping trip. Assume there is only one grocery store, and there are never coupons. (It's a hard knock life. 

### Week 5 (Nothing has changed, just reformatted for readability)
- You will need properties for 
  - the user's budget (A dollar amount), 
  - shopping list (a dictionary of GroceryItem: Bool (default the boolean to false)), 
  - a cart (an array of GroceryItem), 
  - the tax rate (a percentage), 
  - the total cost (a dollar amount), 
  - and the balance (a dollar amount). 
 - Only the model should be able to update and access the properties with the exception of total cost and balance; set the access modifiers accordingly.
- Total cost and balance should be a read-only computed variables. 
  - The logic for total cost should use the reduce higher order function on the cart. If an item has no cost stored in the optional value, return the accumulating total. Otherwise, return the cost of the item multiplied times it's quantity added to the accumulating total. After you complete the reduce method, multiply the result with the tax rate and return the total as the computed value. The logic for balance should simply subtract the total from the budget.
   - In order to use your own struct as a key in a dictionary you will have to conform to the protocol Hashable. Thankfully the properties used on this struct already conform to Hashable, so all you have to do is let the compiler know that GroceryItem can conform to Hashable as well.
- Your GroceryItem will have 
    - a name (a string), 
    - a quantity (an int),
    - and a cost (a dollar amount). 
  - The shopping list will not know the cost of the items before the trip, so make cost an optional value. Write a mutating function that will update cost, and another to update quantity in case the grocery store does not have the items in stock.
- Write an GroceryTripError enum that conforms to the Error protocol for the following cases: 
  - If the total exceeds the budget. 
  - If an item is selected that is not on the shopping list.
  - If the quantity exceeds the required amount. 
  - If the quantity falls short of the required amount. 
  - If the tax rate is 0.0.
- Your class initializer will need the parameters for 
  - the user's budget (a dollar amount) 
  - and shopping list (an array of GroceryItem) 
    - You will need to convert the shoppingList array to a dictionary yourself. The rest that are not computed variables should default to logical values.
  - and a tax rate with a default value of 0.0. 
- Converting the array of your own struct to a dictionary requires a few steps. The easiest way to do this is to first ensure your array contains unique values by initializing a Set from your array. Then map over the set and and return a tuple that represent the key-value pair that you want to be your dictionary item. Then use the Dictionary(uniqueKeysWithValues) initializer and pass in your array of tuples that you received from the map high order function.
- Write a function to add a GroceryItem to the cart, which can throw an GroceryTripError. Take in the parameters for cost, quantity and item.
  - If the string does not match any of the GroceryItems' names in the shopping list dictionary, throw the appropriate error.
  - If the quantity does not match the GroceryItem's quantity in the shopping list dictionary, throw the appropriate error.
  - If the quantity matches, update the dictionary's boolean to true and add the GroceryItem with cost to the cart array. Check the new balance and throw an error if necessary.

  - Write another function to remove an item from the cart. Take in the parameter of GroceryItem. Remove it from the array, and find the matching item in the shopping list (if it exists) and update the dictionary's boolean to false.
  - Write a function to checkout that can throw an error. This function will return the remaining items on the shopping list and the remaining budget in a tuple. If the tax rate is 0.0, return the appropriate error. If the balance is negative, throw the appropriate error. Otherwise, remove everything from the shopping list whose boolean evaluates to true and return everything on the shopping list that wasn't purchased, and return the remaining available budget amount. Do not return a dictionary, but return an array of GroceryItem.
  - Write another function to update the tax rate that can throw an error. Take in the appropriate parameter. Be sure to update the total. Throw an error if the new total exceeds the budget.

### Week 6:
  - In your function to add to cart: Allow for the user to override shopping list errors and add the item as they entered it anyway; still throw the final error for exceeding budget if necessary.
- Review your code and consider how you might refactor to improve it.
  - Is any function lengthy? Could you extract code make it its own function? Extracting functions improve readability and their access can be reduced to private methods.
  - Is there part of your code that was difficult to write and is difficult to read? Is there another method you can use that's easier to read? Could you write comments to improve readability? Can you rename variables for clarity?
  - Can you improve spacing? Indentation? Capitalization? Other styling?
