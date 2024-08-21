extends Area2D

enum TYPE {ROCK, BOMB, FURNITURE}

var speed : float = 30
var type : TYPE = TYPE.ROCK
var game_manager

@onready var sprite: Sprite2D = $Sprite
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D

var rock_variations = [
	preload("res://assets/rock-0001.png"),
	preload("res://assets/rock-0002.png"),
]

var bomb_variations = [
	preload("res://assets/bomb-001.png"),
]

var furniture_variations = [
	preload("res://assets/tile_0096.png"),
	preload("res://assets/tile_0247.png"),
	preload("res://assets/tile_0249.png"),
	preload("res://assets/tile_0389.png"),
]

func _ready() -> void:	
	var random = RandomNumberGenerator.new()
	random.randomize()

	var random_size = random.randf_range(0.5, 2)
	scale = Vector2(random_size, random_size)
	
	var random_speed = random.randf_range(30, 70)
	speed = random_speed
	
	type = [TYPE.ROCK, TYPE.BOMB, TYPE.FURNITURE].pick_random()

	match type:
		TYPE.ROCK:
			sprite.texture = rock_variations.pick_random()
		TYPE.BOMB:
			sprite.texture = bomb_variations.pick_random()
		TYPE.FURNITURE:
			sprite.texture = furniture_variations.pick_random()
	
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	position.y += speed * delta

	if position.y > get_viewport_rect().size.y:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	game_manager = get_tree().root.get_node("Game").get_child(0)

	if body.name != "Player":
		particles.emitting = true
		sprite.hide()
		collision_shape_2d.set_deferred("disabled", true)
		return

	body.die()
	particles.emitting = true

	var has_collided = game_manager.get_has_collided()

	# Check if timer is running
	if (has_collided == false):
		game_manager.set_has_collided(true)
	sprite.hide()
	collision_shape_2d.set_deferred("disabled", true)
