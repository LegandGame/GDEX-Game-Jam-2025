class_name Bullet extends CharacterBody2D

var direction : Vector2
var speed : float = 5000.0
var rotation_speed : float = 360.0
signal bullet_complete
@onready var hitbox : Area2D = $Area2D

func _ready() -> void:
	hitbox.area_entered.connect(hit)
	$Autokill.timeout.connect(timeout)

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	rotate(deg_to_rad(rotation_speed) * delta)
	move_and_slide()
	if is_on_wall():
		timeout()

func hit(area : Area2D) -> void:
	bullet_complete.emit()
	self.queue_free()

# backup function
func timeout() -> void:
	bullet_complete.emit()
	self.queue_free()
