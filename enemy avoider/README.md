# Enemy Avoider Game
Tutorial to make a basic 2D character controllers and enemies that chase you

# Setup
1. Create a new Godot project
2. Create a 2D scene
3. Press Ctrl+S to save it as `Main.tcsn`
4. Set the scene as the main scene in Project -> Project Settings -> Application/Run -> Main Scene

# Creating a basic character controller
1. Right click on the node in the scene and choose `Add Child Node`.
2. Create a `CharacterBody2D` node 
    1. Rename the node to `Player`
    2. Set `Motion Mode` to `Floating`
    3. Change `Transform`->`Scale` to (0.5,0.5)
3. Create `Sprite2D` as a child of the Player
    1. Set the `Texture` to icon.svg
4. Create a `CollisionShape2D` as a child of the Player
    1. Set its shape to `RectangleShape2D`
    2. Resize it to match the size of the image
5. Add a script to the Player called `Player.gd`
```
extends CharacterBody2D


const SPEED = 300.0

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
```
6. Move the player to the center of the screen

Now you can use the arrow keys to move the player

# Creating the enemy
1. Create a new scene
2. Ctrl_S to save the scene and call it `Enemy.tcsn`
2. Change type of the root node in the scene to a `CharacterBody2D` node in the scene
    1. Rename the node to `Enemy`
    2. Set `Motion Mode` to `Floating`
	3. Set Transform -> Scale to (0.25, 0.25)
2. Create `Sprite2D` as a child of the Enemy
    1. Set the `Texture` to icon.svg
    2. Change `Visibility`->`Modulate` to red
3. Create a `CollisionShape2D` as a child of the Enemy
    1. Set its shape to `RectangleShape2D`
    2. Resize it to match the size of the image
4. Add a script to the Enemy called `Enemy.gd`
    ```
    extends CharacterBody2D

    @onready var player = $"../Player"

    const SPEED = 100


    # Called every frame. 'delta' is the elapsed time since the previous frame.
    func _process(delta):
        velocity = position.direction_to(player.position) * SPEED
        move_and_slide()
    ```
5. Bring the Enemy scene into the main scene

# Creating an enemy spawner
1. Create a `Timer` node as a child of the root node in the main scene
    1. Set `Wait Time` to 4s
    2. Make sure `Autostart` is false
    3. Set `Autostart` to true
2. Add a script to the root node of the main scene
    1. Attach the `timeout()` signal from the timer node to the new script
    2. At the top of the script, add `var enemy = preload("res://Enemy.tscn")`
    3. Inside the timeout function
        ```
        var enemy_instance = enemy.instantiate()
        add_child(enemy_instance)
        ```

# Spawn inemeies in random locations
1. Add a `Node2d` as a child of the root node in the main scene
2. Set its group to `spawnpoint`
3. Ctrl+D to duplicate the node 3 times
4. Move the spawn points outside the 4 corners of the screen
5. In t=he main script add `var rng = RandomNumberGenerator.new()`
6. In the timeout function of the main script
    ```
    var spawnpoints = get_tree().get_nodes_in_group("spawnpoint")
	var spawn_index = rng.randf_range(0, 4)
    ```
    Then after the enemy is instantiated
    `enemy_instance.global_position = spawnpoints[spawn_index].global_position`

# Ending the game when an enemy touches the player
1. Add an `Area2D` as a child of the player
2. Add a `CollisionShape2D` as a child of the `Area2D`
    1. Set its shape to `RectangleShape2D`
    2. Resize it to be slightly bigger than the other collision shape on the player
3. Connect the `BodyEntered()` signal to the player script
    In the new function, add `get_tree().quit()`
4. In `Collision`->`Layer` on the Player
    1. Deselect `1`
    2. Select `2`