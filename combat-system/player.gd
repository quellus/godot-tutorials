extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = velocity.lerp(Vector2.ZERO, 0.5)

	move_and_slide()


func _on_hurt_detector_hurt_box_detected(damage: int) -> void:
	print("Player took ", damage, " damage")