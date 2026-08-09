
extends Area2D

@onready var star_1 = $"22StarPngImage1"
@onready var star_2 = $"22StarPngImage2"
@onready var star_3 = $"22StarPngImage3"
@onready var star_4 = $"22StarPngImage4"
@onready var star_5 = $"22StarPngImage5"


'''func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.score += 1
		print(body.score)
		self.queue_free()'''


func stars_collected_ui(body: Node2D):
	if body.score == 1:
		star_1.show() 
	if body.score == 2:
		star_2.show()
	if body.score == 3:
		star_3.show()
	if body.score == 4:
		star_4.show()
	if body.score == 5:
		star_5.show()


func _on_star_1_star_collected(body) -> void:
	pass # Replace with function body.
	if body.score == 1:
		star_1.show() 
	if body.score == 2:
		star_2.show()
	if body.score == 3:
		star_3.show()
	if body.score == 4:
		star_4.show()
	if body.score == 5:
		star_5.show()
