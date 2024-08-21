extends Node

@onready var timer_label: Label = $TimerLabel
@onready var death_timer: Timer = $DeathTimer

var timer_on = false
var time = 0
var has_collided = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if has_collided:
		return
	
	if !timer_on:
		start_timer()
	
	time += delta
	var secs = fmod(time, 60)
	var mins = fmod(time, 60 * 60) / 60
	
	var time_passed = "%02d:%02d" % [mins, secs]
	timer_label.text = time_passed

func stop_timer() -> void:
	timer_on = false
	time = 0
	
func get_current_time() -> float:
	return time

func start_timer() -> void:
	timer_on = true

func set_has_collided(value: bool) -> void:
	if (has_collided):
		return

	has_collided = value
	death_timer.start()
	stop_timer()

func get_has_collided() -> bool:
	return has_collided

func _on_death_timer_timeout() -> void:
	Engine.time_scale = 1.0
	has_collided = false
	get_tree().reload_current_scene()
