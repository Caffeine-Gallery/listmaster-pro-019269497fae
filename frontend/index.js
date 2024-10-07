import { backend } from 'declarations/backend';

document.addEventListener('DOMContentLoaded', async () => {
  const shoppingList = document.getElementById('shopping-list');
  const addItemForm = document.getElementById('add-item-form');
  const newItemInput = document.getElementById('new-item-input');

  // Function to render the shopping list
  async function renderShoppingList() {
    const items = await backend.getItems();
    shoppingList.innerHTML = '';
    items.forEach(item => {
      const li = document.createElement('li');
      li.className = `shopping-item ${item.completed ? 'completed' : ''}`;
      li.innerHTML = `
        <span>${item.name}</span>
        <button class="delete-btn"><i class="fas fa-trash"></i></button>
      `;
      li.addEventListener('click', () => toggleItem(item.id, !item.completed));
      li.querySelector('.delete-btn').addEventListener('click', (e) => {
        e.stopPropagation();
        deleteItem(item.id);
      });
      shoppingList.appendChild(li);
    });
  }

  // Function to add a new item
  async function addItem(name) {
    await backend.addItem(name);
    newItemInput.value = '';
    renderShoppingList();
  }

  // Function to toggle item completion status
  async function toggleItem(id, completed) {
    await backend.updateItem(id, completed);
    renderShoppingList();
  }

  // Function to delete an item
  async function deleteItem(id) {
    await backend.deleteItem(id);
    renderShoppingList();
  }

  // Event listener for form submission
  addItemForm.addEventListener('submit', (e) => {
    e.preventDefault();
    const name = newItemInput.value.trim();
    if (name) {
      addItem(name);
    }
  });

  // Initial render
  renderShoppingList();
});
