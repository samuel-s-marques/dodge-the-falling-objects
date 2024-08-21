extends CharacterBody2D

const SPEED = 150.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.play("walking")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite.play("idle")

	move_and_slide()

func die() -> void:
	death_sound.play()
	
	Engine.time_scale = 0.5
	set_process(false)
	particles.emitting = true
	collision_shape_2d.set_deferred("disabled", true)
	sprite.hide()
