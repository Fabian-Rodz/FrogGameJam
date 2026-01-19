extends CharacterBody2D

signal die

const TILE_SIZE = 64
var moving = false
var input_dir
var facing_right = true
var can_move = false
var cur_lily_pad = null
@onready var move_speed = 0.30
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var tween = null

# Sets player sprite looking to the right
func _ready() -> void:
	sprite.flip_h = true

# Input detection
func _physics_process(delta: float) -> void:
	check_collision()
	input_dir = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		input_dir = Vector2(0,-1)
		move()
	elif Input.is_action_pressed("move_down"):
		input_dir = Vector2(0,1)
		move()
	elif Input.is_action_pressed("move_left"):
		input_dir = Vector2(-1,0)
		if (facing_right and !moving and can_move):
			sprite.flip_h = false
			facing_right = false
		move()
	elif Input.is_action_pressed("move_right"):
		input_dir = Vector2(1,0)
		if (!facing_right and !moving and can_move):
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
			tween = create_tween()
			# tweening allows smooth movement from one position to another
			# (object to tween, current position, next position, speed of movement)
			tween.tween_property(self, "position", new_pos, move_speed)
			# Turns moving to false once movement is over
			tween.tween_callback(move_false)
			
# Identifies that the player stopped moving
func move_false():
	moving = false
	if can_move:
		sprite.play("red_idle")
	tween = null

# Controls game boundaries
func in_bounds(pos) -> bool:
	if pos.y < 213 and pos.y > 19 and pos.x < 343 and pos.x > 21:
		return true
	return false

# hit by snake detection
func _on_area_2d_body_entered(body: Node2D) -> void:
	can_move = false
	if tween != null:
		tween.stop()
	die.emit()

# Lily pad collisions
func _on_area_2d_area_entered(area: Area2D) -> void:
	can_move = true
	cur_lily_pad = area
	check_collision()

func _on_area_2d_area_exited(area: Area2D) -> void:
	can_move = false
	cur_lily_pad = null

# Kills player if no lily pad is available
func check_collision():
	if cur_lily_pad != null:
		if cur_lily_pad.missing:
			can_move = false
			die.emit()
