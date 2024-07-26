extends Control

@onready var health_label = $VBoxContainer/HealthLabel

func update_health(health):
	health_label.text = str(health)
