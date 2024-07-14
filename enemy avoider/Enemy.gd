extends CharacterBody2D

@onready var player = $"../Player"

const SPEED = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = position.direction_to(player.position) * SPEED
	move_and_slide()
