# Enemy Avoider Game
Tutorial to make a basic 2D character controller and enemies that chase you.

If you want to make a top-down game. Whether it’s a survivors-like, shooter, or RPG. This tutorial will be a good starting point. Well go over controlling your character, spawning enemies that chase your character, and taking damage when an enemy touches you.

# Setup
1. Create a new Godot project
2. Create a 2D scene
3. Rename the Node2D to Main
4. Press Ctrl+S to save it as `Main.tcsn`
5. Set the scene as the main scene in Project -> Project Settings -> Application/Run -> Main Scene
6. Create keybinds for WASD in Project -> Project Settings -> Input Map
    1. Add new action called `up`
        - Press the plus and select `W`
    2. Add new action called `left`
        - Press the plus and select `A`
    3. Add new action called `down`
        - Press the plus and select `S`
    4. Add new action called `right`
        - Press the plus and select `D`

# Creating a basic character controller
1. Right click on the node in the scene and choose `Add Child Node`.
2. Create a `CharacterBody2D` node 
    1. Rename the node to `Player`
    2. Set `Motion Mode` to `Floating`
        - Since this is top down, there is no gravity. Godot will apply gravity to your CharacterBody2D in certain situations and setting it to floating tells it no to do that.
3. Create `Sprite2D` as a child of the Player
    1. Set the `Texture` to icon.svg
    2. Change `Transform`->`Scale` to (0.5,0.5)
4. Create a `CollisionShape2D` as a child of the Player
    1. Set its shape to `RectangleShape2D`
    2. Resize it to match the size of the image
5. Add a script to the Player called `Player.gd`
    ```
    extends CharacterBody2D


    const SPEED = 300.0

    func _physics_process(delta):
        var direction = Input.get_vector("left", "right", "up", "down")
        if direction:
            velocity = direction * SPEED
        else:
            velocity = velocity.lerp(Vector2.ZERO, 0.5)

        move_and_slide()
    ```
    - Input.get_vector returns a Vector2 pointing in the direction of your inputs. It can be directly applied to the velocity
    - When there's no input, we don't want to stop walking immediately, so we slow to a stop over a few frames to make the movement feel smoother
    - Finally, we call `move_and_slide()` to tell the engine to use the velocity to move the character. Godot uses time for this function, so the movement speed should be the same regardless of framerate.
6. Move the player to the center of the screen

Now you can use the arrow keys to move the player

# Creating the enemy
1. Create a new scene
2. Ctrl+S to save the scene and call it `Enemy.tcsn`
2. Change type of the root node in the scene to a `CharacterBody2D` node in the scene
    1. Rename the node to `Enemy`
    2. Set `Motion Mode` to `Floating`
2. Create `Sprite2D` as a child of the Enemy
    1. Set the `Texture` to icon.svg
	2. Set Transform -> Scale to (0.25, 0.25)
    3. Change `Visibility`->`Modulate` to red
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
    - Every frame, the enemy gets the direction to the player and moves towards it using a similar method to the player controller
5. Bring the Enemy scene into the main scene, run the game and test that it chases the player

# Creating an enemy spawner
1. Delete the enemy from the scene as we will be spawning it in code 
2. Create a `Timer` node as a child of the root node in the main scene
    1. Set `Wait Time` to 4s
    2. Make sure `Autostart` is false
    3. Set `Autostart` to true
3. Add a script to the root node of the main scene
    1. Attach the `timeout()` signal from the timer node to the new script
    2. At the top of the script, add `var enemy = preload("res://Enemy.tscn")`
    3. Inside the timeout function:
        ```
        var enemy_instance = enemy.instantiate()
        add_child(enemy_instance)
        ```
        - This creates an enemy and adds it as a child of the main scene

# Spawn enemies in random locations
1. Add a `Node2d` as a child of the root node in the main scene
2. Rename it to "SpawnPoint"
3. Set its group to `spawnpoint`
4. Ctrl+D to duplicate the node 3 times
5. Move the spawn points outside the 4 corners of the screen
6. In the main script add `var rng = RandomNumberGenerator.new()`
7. In the timeout function of the main script
    ```
    var spawnpoints = get_tree().get_nodes_in_group("spawnpoint")
	var spawn_index = rng.randf_range(0, 4)
    ```
    Then after the enemy is instantiated
    `enemy_instance.global_position = spawnpoints[spawn_index].global_position`

# Ending the game when an enemy touches the player
1. In the enemy script, add `class_name Enemy` to the top line
2. Back in the Player script
3. Add an `Area2D` as a child of the player
4. Add a `CollisionShape2D` as a child of the `Area2D`
    1. Set its shape to `RectangleShape2D`
    2. Resize it to be slightly bigger than the other collision shape on the player
5. On the Area2D, connect the `body_entered()` signal to the player script
    In the new function, add `get_tree().quit()`