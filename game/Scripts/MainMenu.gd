extends Control

func _ready():
	$VBoxContainer2/Logo.set_animation("idle")

func _on_Play_Button_pressed():
	get_tree().change_scene("res://Scenes/Gameplay.tscn")

func _on_Tuto_Button_pressed():
	var status := get_tree().change_scene("res://Scenes/Intro.tscn")
	assert(status == OK)


func _on_VBoxContainer2_mouse_entered():
	$VBoxContainer2/Logo.set_animation("hover")


func _on_Logo_animation_finished():
	$VBoxContainer2/Logo.set_animation("idle")
