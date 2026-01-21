extends Node2D

@export var snake_scene: PackedScene
var dragonfly_scene: PackedScene = preload("res://Scenes/dragonfly.tscn")
@onready var ui = $UI
var score = 0
@onready var score_timer: Timer = $Timers/ScoreTimer
@onready var snake_timer: Timer = $Timers/SnakeTimer
@onready var dragonfly_timer: Timer = $Timers/DragonflyTimer
@onready var start_timer: Timer = $Timers/StartTimer
@onready var death_timer: Timer = $Timers/DeathTimer
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	start_timer.start()
	score = 0
	hud.update_score(score)
	hud.hide()

func game_over() -> void: # Connected to the "die" signal
	snake_timer.stop()
	dragonfly_timer.stop()
	score_timer.stop()
	$Frog/Area2D/HopCollision.set_deferred("disabled", true)
	$Frog/CollisionShape2D.set_deferred("disabled", true)
	if $Frog.moving:
		$Frog.sprite.play("red_hit_moving")
	else:
		$Frog.sprite.play("red_hit_grounded")
	death_timer.start()

# Reload scene 3 seconds after death
func _on_death_timer_timeout() -> void:
	hud.hide()
	ui.show_game_over()

# Determines intervals where snakes spawn
func _on_start_timer_timeout() -> void:
	snake_timer.start()
	dragonfly_timer.start()
	hud.show()
	score_timer.start()
	print("Timers started")
	
func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)

# Spawns snake once the interval is reached
func _on_snake_timer_timeout() -> void:
	# New snake instance
	var snake = snake_scene.instantiate()
	
	var snake_spawn_location = $SnakePath/SnakeSpawnLocation
	snake_spawn_location.progress_ratio = randf()
	# Verifies snake spawn is not on the top or bottom of screen, only on the sides
	while snake_spawn_location.position.x > -24 and snake_spawn_location.position.x < 400:
		snake_spawn_location.progress_ratio = randf()
	
	snake.position = snake_spawn_location.position
	
	# Snakes slither directly towards the player
	var slope = ($Frog.position.y - snake.position.y) / ($Frog.position.x - snake.position.x)
	var direction = tan(slope)
	
	# Rotates the snake depending on if they spawn on the left or right
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


func _on_dragonfly_timer_timeout() -> void:
	# New dragonfly instance
	var dragonfly = dragonfly_scene.instantiate()
	
	dragonfly.eaten.connect(_on_dragonfly_eaten)
	
	# CHoose a random location on Path2D
	var dragonfly_spawn_location = $DragonflyPath/DragonflySpawnLocation
	dragonfly_spawn_location.progress_ratio = randf()
	
	# Set the dragonfly's position to the random location
	dragonfly.position = dragonfly_spawn_location.position
	
	# Set the dragonfly's direction perpendicular to the path direction.
	var direction = dragonfly_spawn_location.rotation + PI / 2
	
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	dragonfly.rotation = direction
	dragonfly.velocity = Vector2.RIGHT.rotated(direction) * randf_range(25.0, 75.0)

	# Spawn the mob by adding it to the Main scene.
	add_child(dragonfly)

func _on_dragonfly_eaten() -> void:
	score += 10
	hud.update_score(score)
