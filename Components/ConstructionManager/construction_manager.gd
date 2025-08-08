class_name ConstructionManager extends Node2D

@export var grid_size : int = 16

@onready var build_point : Marker2D = $BuildPoint
@onready var sprite : Sprite2D = $BuildPoint/PreviewSprite
@onready var overlap : Area2D = $BuildPoint/OverlapArea
@onready var overlap_shape : CollisionPolygon2D = $BuildPoint/OverlapArea/CollisionPolygon2D

var loaded_construct : ConstructInfo
var construct_is_loaded : bool = false
var overlap_count : int = 0

signal building_placed

func _ready() -> void:
	overlap.body_entered.connect(_on_body_entered)
	overlap.body_exited.connect(_on_body_exited)


func _on_body_entered(_body : Node2D) -> void:
	overlap_count += 1
func _on_body_exited(_body : Node2D) -> void:
	overlap_count -= 1

func align_to_grid(position : Vector2) -> Vector2i:
	var x = (roundi(position.x) / grid_size) * grid_size
	var y = (roundi(position.y) / grid_size) * grid_size
	return Vector2i(x, y)

func update_build_point(position : Vector2):
	build_point.position = align_to_grid(position)

func load_construct(construct : ConstructInfo) -> void:
	loaded_construct = construct
	sprite.texture = construct.preview_sprite
	overlap_shape.polygon = construct.build_area
	construct_is_loaded = true

func unload_construct() -> void:
	loaded_construct = ConstructInfo.new()
	sprite.texture = Texture2D.new()
	overlap_shape.polygon = []
	construct_is_loaded = false

func ready_to_build() -> bool:
	if construct_is_loaded and overlap_count == 0:
		return true
	else:
		return false

func build_loaded_construct() -> void:
	if not ready_to_build():
		return
	var new_construct = loaded_construct.construct_scene.instantiate()
	new_construct.position = build_point.position
	get_parent().call_deferred("add_child", new_construct)
	building_placed.emit()
