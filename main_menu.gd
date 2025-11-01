extends Control

func _on_play_pressed():
	# Change de scène vers ton jeu principal
	get_tree().change_scene_to_file("res://scenes/main.tscn")




func _on_quit_pressed():
	get_tree().quit()


func _on_option_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/option_menu.tscn")
