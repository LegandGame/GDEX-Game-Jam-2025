extends Node2D

@onready var turn_manager := $TurnManager
@onready var ui := $UI

@export_category("Level Parameters")
@export var turns_to_complete : int
var turn_count : int = 0
enum TURN{ALLY, ACTIVATION, ENEMY}
var current_turn : TURN = TURN.ALLY

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	pass
