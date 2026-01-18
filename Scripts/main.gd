extends Node2D

@export var snake_scene: PackedScene

func _ready() -> void:
	$StartTimer.start()

func game_over() -> void: # Connected to the "die" signal
	$SnakeTimer.stop()
	$Frog/Area2D/HopCollision.set_deferred("disabled", true)
	if $Frog.moving:
		$Frog.sprite.play("red_hit_moving")
	else:
		$Frog.sprite.play("red_hit_grounded")
	$DeathTimer.start()

# Reload scene 3 seconds after death
func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()

# Determines intervals where snakes spawn
func _on_start_timer_timeout() -> void:
	$SnakeTimer.start()

# Spawns snake once the interval is reached
func _on_snake_timer_timeout() -> void:
	# New snake instance
	var snake = snake_scene.instantiate()
	
	var snake_spawn_location = $SnakePath/SnakeSpawnLocation
	snake_spawn_location.progress_ratio = randf()
	while snake_spawn_location.position.x > -24 and snake_spawn_location.position.x < 400:
		snake_spawn_location.progress_ratio = randf()
	
	snake.position = snake_spawn_location.position
	print("Snake Position: " + str(snake.position))
	
	# Snakes slither directly towards the player
	var slope = ($Frog.position.y - snake.position.y) / ($Frog.position.x - snake.position.x)
	var direction = tan(slope)
	
	if snake_spawn_location.position.x <= -24:
		snake.rotate_sprite(false)
	elif snake_spawn_location.position.x >= 400:
		snake.rotate_sprite(true)
		direction -= PI
	
	# The snakes the direction is given a random offset from the player
	direction += randf_range(-PI/8 , PI/8)
	snake.rotation = direction
	
	var velocity = Vector2(randf_range(150.0, 200.0), 0.0)
	snake.linear_velocity = velocity.rotated(direction)
	
	add_child(snake)
