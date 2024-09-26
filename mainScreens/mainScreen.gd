extends Node

@onready var start_button = $StartButton
@onready var quit_button = $QuitButton

func _ready():
	if start_button:
		start_button.connect("pressed", Callable(self, "_on_start_button_pressed"))
	else:
		push_error("StartButton node not found in the scene.")

	if quit_button:
		quit_button.connect("pressed", Callable(self, "_on_quit_button_pressed"))
	else:
		push_error("QuitButton node not found in the scene.")

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://levelSystem/gameScene.gd")

func _on_quit_button_pressed():
	get_tree().quit()
