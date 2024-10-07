import Bool "mo:base/Bool";
import Func "mo:base/Func";
import Hash "mo:base/Hash";

import Array "mo:base/Array";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Option "mo:base/Option";
import Text "mo:base/Text";

actor {
  // Define the ShoppingItem type
  type ShoppingItem = {
    id: Nat;
    name: Text;
    completed: Bool;
  };

  // Stable variable to store the shopping list items
  stable var nextId: Nat = 0;
  stable var stableItems: [(Nat, ShoppingItem)] = [];

  // Create a HashMap to store the shopping list items
  var items = HashMap.HashMap<Nat, ShoppingItem>(0, Nat.equal, Nat.hash);

  // Function to add a new item to the shopping list
  public func addItem(name: Text) : async Nat {
    let id = nextId;
    let newItem: ShoppingItem = {
      id = id;
      name = name;
      completed = false;
    };
    items.put(id, newItem);
    nextId += 1;
    id
  };

  // Function to get all items in the shopping list
  public query func getItems() : async [ShoppingItem] {
    Iter.toArray(items.vals())
  };

  // Function to update the completed status of an item
  public func updateItem(id: Nat, completed: Bool) : async Bool {
    switch (items.get(id)) {
      case (null) { false };
      case (?item) {
        let updatedItem: ShoppingItem = {
          id = item.id;
          name = item.name;
          completed = completed;
        };
        items.put(id, updatedItem);
        true
      };
    }
  };

  // Function to delete an item from the shopping list
  public func deleteItem(id: Nat) : async Bool {
    switch (items.remove(id)) {
      case (null) { false };
      case (?_) { true };
    }
  };

  // System functions to handle upgrades
  system func preupgrade() {
    stableItems := Iter.toArray(items.entries());
  };

  system func postupgrade() {
    items := HashMap.fromIter<Nat, ShoppingItem>(stableItems.vals(), 0, Nat.equal, Nat.hash);
  };
}
