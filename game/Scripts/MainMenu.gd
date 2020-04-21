extends Control

func _on_Play_Button_pressed():
	get_tree().change_scene("res://Scenes/Gameplay.tscn")

func _on_Tuto_Button_pressed():
	get_tree().change_scene("res://Scenes/Intro.tscn")
