extends Node2D

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var timer: Timer = $Timer
@onready var game_manager: Node = %GameManager
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var SPEED = 120
var direction = 1
var dropped_object = false
var level = 1
const LEVEL_TIME_INTERVAL = 10
const TIMER_LEVELS = {1: 1, 2: 0.7, 3: 0.5, 4: 0.2, 5: 0}

func update_level(new_level: int, speed_increase: int, timer_value: float):
	level = new_level
	direction *= -1
	SPEED += speed_increase
	timer.wait_time = timer_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1

	position.x += direction * SPEED * delta
	var current_time = game_manager.get_current_time()


	for lvl in range(1, 5):
		var min_time = lvl * LEVEL_TIME_INTERVAL
		var max_time = (lvl + 1) * LEVEL_TIME_INTERVAL
		
		if current_time >= min_time and current_time < max_time and level == lvl:
			var timer_value = TIMER_LEVELS.get(lvl, 0.2)
			update_level(lvl + 1, 30, timer_value)
			break

	if dropped_object == false:
		sprite.play("throwing")
		
		var object_scene = preload("res://scenes/falling_object.tscn")
		var falling_object = object_scene.instantiate()
		falling_object.position = self.position
		falling_object.position.y = self.position.y + 25

		get_tree().root.add_child(falling_object)

		dropped_object = true
		timer.start()
		
		sprite.play("moving")

func _on_timer_timeout() -> void:
	dropped_object = false
