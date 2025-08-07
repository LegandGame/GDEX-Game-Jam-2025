class_name ConstructionManager extends Node2D

@export var grid_size : int = 16

@onready var build_point : Marker2D = $BuildPoint
@onready var sprite : Sprite2D = $BuildPoint/PreviewSprite
@onready var overlap : Area2D = $BuildPoint/OverlapArea
@onready var overlap_shape : CollisionPolygon2D = $BuildPoint/OverlapArea/CollisionPolygon2D

var loaded_construct : ConstructInfo
var ready_to_build : bool = false

signal building_placed(construct)

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
	ready_to_build = true

func unload_construct() -> void:
	loaded_construct = ConstructInfo.new()
	sprite.texture = Texture2D.new()
	overlap_shape.polygon = []
	ready_to_build = false

func build_construct(construct : ConstructInfo, position : Vector2i) -> void:
	if not ready_to_build:
		return
	var new_construct = construct.construct_scene.instantiate()
	new_construct.position = position
	get_parent().call_deferred("add_child", new_construct)
