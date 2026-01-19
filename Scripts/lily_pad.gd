extends Area2D


@onready var sprite : Sprite2D = $Sprite2D
@onready var collision : CollisionShape2D = $CollisionShape2D
@onready var fade_speed = 0.3
var fade = false
var missing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if fade:
		var color = sprite.modulate
		color.a -= fade_speed*delta
		color.a = max(color.a, 0.0)
		sprite.modulate = color
		
		if color.a == 0.0:
			sprite.hide()
			fade = false
			missing = true
			$Spawn.start()
			
	elif !missing and sprite.modulate.a < 1.0:
		var color = sprite.modulate
		color.a = 1.0
		sprite.modulate = color
		sprite.show()
	
			
		
func _on_body_entered(body: Node2D) -> void:
	fade = true


func _on_spawn_timeout() -> void:
	missing = false
	sprite.show()
