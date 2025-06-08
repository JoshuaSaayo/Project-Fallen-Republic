extends Sprite2D

func _ready():
	# Create circular spark
	var image = Image.create(32, 32, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	
	for x in 32:
		for y in 32:
			var dist = Vector2(x-16, y-16).length()
			if dist <= 16:
				var alpha = 1.0 - dist/16.0
				image.set_pixel(x, y, Color(1, 0.65, 0, alpha))
	
	var texture = ImageTexture.create_from_image(image)
	self.texture = texture
	
	# Fade out
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_callback(queue_free)
