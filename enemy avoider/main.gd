extends Node2D

var enemy = preload("res://Enemy.tscn")




func _on_enemy_spawn_timer_timeout():
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
