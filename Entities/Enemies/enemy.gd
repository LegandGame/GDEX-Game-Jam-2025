class_name Enemy extends Node2D

var bullet_scene := preload("res://Entities/Bullet/bullet.tscn")

@onready var hitbox : Area2D = $Hitbox
@onready var sprite : Sprite2D = $Sprite2D

var firing_casts : Array[RayCast2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(_on_hitbox_hit)
	for child in $FiringPorts.get_children():
		if child is RayCast2D:
			firing_casts.append(child)


func activate() -> void:
	for f in firing_casts:
		var new_bullet = bullet_scene.instantiate()
		new_bullet.direction = f.target_position


func _on_hitbox_hit(area : Area2D) -> void:
	die()

func die() -> void:
	sprite.hide()
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)

func reset() -> void:
	sprite.show()
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)
