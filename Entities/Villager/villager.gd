class_name Villager extends Node2D

@onready var hitbox : Area2D = $Hitbox
@onready var sprite : Sprite2D = $Sprite2D

signal villager_died(villager)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(_on_hitbox_hit)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hitbox_hit(area : Area2D) -> void:
	die()

func die() -> void:
	villager_died.emit(self)
	sprite.hide()
	hitbox.set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)

func reset() -> void:
	sprite.show()
	hitbox.set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)
