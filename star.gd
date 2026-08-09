extends Area2D

signal star_collected


func _on_body_entered(body: Node2D) -> void:
	star_collected.emit()
	if body.name == "player":
		self.queue_free()
