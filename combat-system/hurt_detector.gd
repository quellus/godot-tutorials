class_name HurtDetector extends Area2D

signal hurt_box_detected(damage: int)

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is HurtBox:
		hurt_box_detected.emit(area.damage)
