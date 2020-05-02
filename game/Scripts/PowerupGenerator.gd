extends Node

export var spawn_radius = 200
const powerups = [
	preload("res://Scenes/PowerUpElecAtt.tscn"), 
	preload("res://Scenes/PowerUpMagnetic.tscn")
]
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _place_powerup():
	# select random position within spawn radius
	var spawn_position = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)) * rng.randf_range(0, spawn_radius)
	
	# select a random powerup from our list
	var powerup = powerups[rng.randi() % powerups.size()].instance()
	
	# place the powerup at selected position
	powerup.position = spawn_position
	self.add_child(powerup)


func _on_SpawnTimer_timeout():
	_place_powerup()
