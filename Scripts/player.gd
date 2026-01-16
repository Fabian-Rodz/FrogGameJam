extends CharacterBody2D

const TILE_SIZE = 64
var moving = false
var input_dir
var facing_right = true
var can_move = false
@onready var move_speed = 0.30
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var x_pos = 0
var y_pos = 0

func _ready() -> void:
	# faces right
	sprite.flip_h = true
	print("Current Position: (" + str(position.x) + ", " + str(position.y) + ")")


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
	#velocity = input_dir * 10000 * delta
	move_and_slide()
	
func move():
	if input_dir:
		var new_pos = position + input_dir * TILE_SIZE
		$Area2D.global_position = new_pos
		if moving == false and in_bounds(new_pos) and can_move:
			sprite.play("red_hops")
			moving = true
			var tween = create_tween()
			# tweening allows smooth movement from one position to another
			# (object to tween, current position, next position, speed of movement)
			tween.tween_property(self, "position", new_pos, move_speed)
			# Turns moving to false once movement is over
			tween.tween_callback(move_false)
			
func move_false():
	moving = false
	sprite.play("red_idle")
	print("New Position: (" + str(position.x) + ", " + str(position.y) + ")")

func in_bounds(pos) -> bool:
	if pos.y < 213 and pos.y > 19 and pos.x < 343 and pos.x > 21:
		return true
	return false
	
func _on_area_2d_can_move() -> void:
	can_move = true
