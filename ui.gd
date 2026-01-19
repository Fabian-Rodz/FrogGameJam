extends CanvasLayer

@onready var background = $Background
@onready var start_button = $Background/VBoxContainer/StartButton
@onready var restart_button = $Background/VBoxContainer/RestartButton




func _ready():
	show_start_menu()

func show_start_menu():
	background.visible = true
	start_button.visible = true
	restart_button.visible = false
	get_tree().paused = true

func show_game_over():
	background.visible = true
	start_button.visible = false
	restart_button.visible = true
	get_tree().paused = true

func hide_menu():
	background.visible = false
	start_button.visible = false
	restart_button.visible = false
	get_tree().paused = false


func _on_start_button_pressed() -> void:
	print("Before:", get_tree().paused)
	hide_menu()
	print("After:", get_tree().paused)


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
