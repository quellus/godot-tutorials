# Enemy Avoider Game
Tutorial to make a basic 2D character controllers and enemies that chase you

# Setup
1. Create a new Godot project
2. Create a 2D scene and name it `Main.tcsn`
3. Set the scene as the main scene in Project -> Project Settings -> Application/Run -> Main Scene

# Creating a basic character controller
1. Create a `CharacterBody2D` node in the scene
    1. Rename the node to `Player`
    2. Set `Motion Mode` to `Floating`
2. Create `Sprite2D` as a child of the Player
    1. Set the `Texture` to icon.svg
3. Create a `CollisionShape2D` as a child of the Player
    1. Set its shape to `RectangleShape2D`
    2. Resize it to match the size of the image
4. Add a script to the Player called `Player.gd`
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

Now you can use the arrow keys to move the player

# Creating the enemy
1. Create a `CharacterBody2D` node in the scene
    1. Rename the node to `Enemy`
    2. Set `Motion Mode` to `Floating`
	3. Set Transform -> Scale to (0.5, 0.5)
2. Create `Sprite2D` as a child of the Player
    1. Set the `Texture` to icon.svg
3. Create a `CollisionShape2D` as a child of the Player
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