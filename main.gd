extends Node2D

func _ready():
	Utils.loadGame()

func _on_quit_pressed():
	Game.playerHP = 10
	Game.gold = 0
	Utils.saveGame()
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
