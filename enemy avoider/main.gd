extends Node2D

var enemy = preload("res://Enemy.tscn")
var rng = RandomNumberGenerator.new()



func _on_enemy_spawn_timer_timeout():
	var spawnpoints = get_tree().get_nodes_in_group("spawnpoint")
	var spawn_index = rng.randf_range(0, 4)
	var enemy_instance = enemy.instantiate()
	add_child(enemy_instance)
	enemy_instance.global_position = spawnpoints[spawn_index].global_position
