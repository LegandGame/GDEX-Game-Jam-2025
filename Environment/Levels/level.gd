extends Node2D

@onready var turn_manager := $TurnManager
@onready var ui := $UI
@onready var construction_manager := $ConstructionManager

@export_category("Level Parameters")
@export var turns_to_complete : int
var current_turn_count : int = 0
enum TURN{ALLY, ACTIVATION, ENEMY}
var current_turn_type : TURN = TURN.ALLY

@export var defence_building_list : Array[ConstructInfo]

@export var enemy_building_list : Array[ConstructInfo]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	ui.update_turn_count(current_turn_count, turns_to_complete)

func connect_signals() -> void:
	ui.ui_play_button_pressed.connect(play)
	ui.ui_reset_button_pressed.connect(reset_level)
	ui.ui_building_button_pressed.connect(select_building)

func reset_level() -> void:
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	construction_manager.update_build_point(get_viewport().get_mouse_position())

# PLAY BUTTON FUNCTIONS
# -----------------------------
var villager_list : Array
var villager_count : int
var villager_death_count : int = 0
var enemy_list : Array

func play() -> void:
	construction_manager.unload_construct()
	# get villager list
	if !villager_list:
		lazy_init_villager_list()
	
	# run through all the enemies
	enemy_list = get_tree().get_nodes_in_group("Enemy")
	enemy_list.sort_custom(sort_enemy_list)
	for e in enemy_list:
		await e.activate()
		await get_tree().create_timer(0.1).timeout
	
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

# CONSTRUCTION MANAGER STUFF
# ---------------------------
func select_building(slot : int) -> void:
	# prevent out of bounds
	match current_turn_type:
		TURN.ALLY:
			if slot >= defence_building_list.size():
				construction_manager.unload_construct()
				return
		TURN.ENEMY:
			if slot >= enemy_building_list.size():
				construction_manager.unload_construct()
				return
	var temp_con
	match current_turn_type:
		TURN.ALLY:
			temp_con = defence_building_list[slot]
		TURN.ENEMY:
			temp_con = enemy_building_list[slot]
	construction_manager.load_construct(temp_con)

func building_placed() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		construction_manager.build_loaded_construct()
