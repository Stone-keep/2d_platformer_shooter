extends Area2D

var direction: Vector2
var speed := 200

func _physics_process(delta: float) -> void:
    position += direction * speed * delta
    
func _ready() -> void:
    var crosshair_tween = get_tree().create_tween()
    crosshair_tween.tween_property($BulletSprite, "scale", Vector2(1.0, 1.0), 0.2).from(Vector2.ZERO)

func _on_screen_exited() -> void:
    queue_free()

func setup(pos: Vector2, dir: Vector2):
    position = pos + dir * 15
    direction = dir