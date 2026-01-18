extends RigidBody2D

func _ready() -> void:
	$AnimatedSprite2D.flip_h = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func rotate_sprite(case: bool)-> void:
	$AnimatedSprite2D.flip_v = case
	# Idk why but the flip_v makes the collision appear separate to the sprite
	if case == true:
		$AnimatedSprite2D.position += Vector2(0,20)
