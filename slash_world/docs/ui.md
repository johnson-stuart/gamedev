# User Interface

## Enemy and Item Names

Enemy and item names are visible above their models using **Label3D** nodes as children of the enemy and weapon pickup nodes.
These can be configured to only be visible when the player is nearby and the **Billboard** setting makes it so that the player can read it regardless of their position.

## HUD

The HUD so far is a **CanvasLayer** node inside of player.gd with a **Button** child node. The button node has an option for an icon, where a .png image can be inserted. 

# Roadmap

- Start Screen
- Pause Menu
- Inventory
- Player and Enemy Health bar
- Damage numbers
- Add more ability buttons
