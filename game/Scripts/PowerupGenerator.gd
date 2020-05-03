extends Node

signal taken_elec_att
signal taken_magnetic
signal taken_polarity_inverter

export var spawn_radius = 200
const powerups = [
	preload("res://Scenes/PowerUpElecAtt.tscn"), 
	preload("res://Scenes/PowerUpMagnetic.tscn"),
	preload("res://Scenes/PowerUpPolarityInverter.tscn")
]
const powerups_signals = [
	"taken_elec_att",
	"taken_magnetic",
	"taken_polarity_inverter"
]
const powerups_handlers = [
	"hander_elec_att",
	"hander_magnetic",
	"hander_polarity_inverter"
]
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _place_powerup():
	# select random position within spawn radius
	var spawn_position = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0)) * rng.randf_range(0, spawn_radius)
	
	# select a random powerup from our list
	var powerup_number = rng.randi() % powerups.size()
	var powerup = powerups[powerup_number].instance()
	powerup.connect(powerups_signals[powerup_number], self, powerups_handlers[powerup_number])
	
	# place the powerup at selected position
	powerup.position = spawn_position
	self.add_child(powerup)


func _on_SpawnTimer_timeout():
	_place_powerup()
	
func hander_elec_att():
	emit_signal("taken_elec_att")
	
func hander_magnetic():
	emit_signal("taken_magnetic")
	
func hander_polarity_inverter():
	emit_signal("taken_polarity_inverter")
