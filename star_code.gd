extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.score += 1
		print(body.score)
		self.queue_free()
		
