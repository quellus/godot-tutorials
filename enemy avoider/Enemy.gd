class_name Enemy extends CharacterBody2D

@onready var player = $"../Player"

const SPEED = 100

func _physics_process(delta):
	velocity = position.direction_to(player.position) * SPEED
	move_and_slide()
