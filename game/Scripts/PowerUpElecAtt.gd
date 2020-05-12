extends Area2D

signal taken_elec_att

func _on_PowerUpElecAtt_body_entered(body):
	if body.is_in_group("balls"):
		hide()
		emit_signal("taken_elec_att")
		$CollisionShape2D.set_deferred("disabled", true)
		queue_free()
