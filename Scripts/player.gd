extends CharacterBody2D

const TILE_SIZE = 64
var moving = false
var input_dir
var facing_right = true
var can_move = false
@onready var move_speed = 0.30
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Sets player sprite looking to the right
func _ready() -> void:
	sprite.flip_h = true
	# For debugging
	print("Current Position: (" + str(position.x) + ", " + str(position.y) + ")")

# Input detection
func _physics_process(delta: float) -> void:
	input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		input_dir = Vector2(0,-1)
		move()
	elif Input.is_action_pressed("move_down"):
		input_dir = Vector2(0,1)
		move()
	elif Input.is_action_pressed("move_left"):
		input_dir = Vector2(-1,0)
		if (facing_right and !moving):
			sprite.flip_h = false
			facing_right = false
		move()
	elif Input.is_action_pressed("move_right"):
		input_dir = Vector2(1,0)
		
		if (!facing_right and !moving):
			sprite.flip_h = true
			facing_right = true
		move()

	move_and_slide()
	
# Verifies movement is valid and handles it if so
func move():
	if input_dir:
		var new_pos = position + input_dir * TILE_SIZE
		if moving == false and in_bounds(new_pos) and can_move:
			sprite.play("red_hops")
			moving = true
			var tween = create_tween()
			# tweening allows smooth movement from one position to another
			# (object to tween, current position, next position, speed of movement)
			tween.tween_property(self, "position", new_pos, move_speed)
			# Turns moving to false once movement is over
			tween.tween_callback(move_false)
			
# Identifies that the player stopped moving
func move_false():
	moving = false
	sprite.play("red_idle")
	# For debugging
	print("New Position: (" + str(position.x) + ", " + str(position.y) + ")")

# Controls game boundaries
func in_bounds(pos) -> bool:
	if pos.y < 213 and pos.y > 19 and pos.x < 343 and pos.x > 21:
		return true
	return false

# Detects collision with lily pads
func _on_area_2d_area_entered(area: Area2D) -> void:
	can_move = true
	print('collision') # Replace with function body.

# Detects if lily pad is missing
func _on_area_2d_area_exited(area: Area2D) -> void:
	can_move = false
	print("lily pad is gone")
