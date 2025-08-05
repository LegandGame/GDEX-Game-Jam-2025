extends Control

@onready var play_button : Button = %PlayButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button.pressed.connect(on_play_pressed)

func on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Environment/Levels/test_level.tscn")
