extends Area2D

signal taken_elec_att

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_PowerUpElecAtt_body_entered(body):
	hide()
	emit_signal("taken_elec_att")
	$CollisionShape2D.set_deferred("disabled", true)
