extends CanvasLayer


signal restart

	
	
func _on_restart_pressed():
	restart.emit()



func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
