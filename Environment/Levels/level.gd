extends Node2D

@onready var turn_manager := $TurnManager
@onready var ui := $UI

@export_category("Level Parameters")
@export var turns_to_complete : int
var current_turn_count : int = 0
enum TURN{ALLY, ACTIVATION, ENEMY}
var current_turn_type : TURN = TURN.ALLY

@export var defence_building_list : Array

@export var enemy_building_list : Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	ui.update_turn_count(current_turn_count, turns_to_complete)

func connect_signals() -> void:
	ui.ui_play_button_pressed.connect(play)


# PLAY BUTTON FUNCTIONS
# -----------------------------
var villager_list : Array
var villager_count : int
var villager_death_count : int = 0
var enemy_list : Array

func play() -> void:
	# get villager list
	if !villager_list:
		lazy_init_villager_list()
	
	# run through all the enemies
	enemy_list = get_tree().get_nodes_in_group("Enemy")
	enemy_list.sort_custom(sort_enemy_list)
	for e in enemy_list:
		await e.activate()
	
	# do something based on current_turn_type and villager_death_count

func lazy_init_villager_list() -> void:
	villager_list = get_tree().get_nodes_in_group("Villager")
	villager_count = villager_list.size()
	for v in villager_list:
		v.villager_died.connect(increment_villager_death_count)

func increment_villager_death_count() -> void:
	villager_death_count += 1

# sort from left to right, top to bottom. 
func sort_enemy_list(a, b) -> bool:
	if a.position.y < b.position.y:
		return true
	elif a.position.y == b.position.y:
		if a.position.x < b.position.x:
			return true
		else:
			return false
	else:
		return false
# -------------------------
