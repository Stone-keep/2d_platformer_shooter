extends Area2D

var direction: Vector2
var speed := 300

func _physics_process(delta: float) -> void:
    position += direction * speed * delta

func _on_screen_exited() -> void:
    queue_free()

func setup(pos: Vector2, dir: Vector2):
    position = pos + dir * 30
    direction = dir