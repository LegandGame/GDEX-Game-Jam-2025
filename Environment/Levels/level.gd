extends Node2D

# node referencess
@onready var turn_manager := $TurnManager
@onready var ui := $UI
@onready var construction_manager := $ConstructionManager

signal level_victory

# turn manager stuff
@export_category("Level Parameters")
@export var turns_to_complete : int
var current_turn_count : int = 0
enum TURN{ALLY, ENEMY}
var current_turn_type : TURN = TURN.ALLY
var is_activation_phase : bool = false

var villager_list : Array
var villager_count : int
var villager_death_count : int = 0
var enemy_list : Array


# building manager stuff
@export var defence_building_list : Array[ConstructInfo]
@export var enemy_building_list : Array[ConstructInfo]
var selected_building_index : int


# ACTUAL LEVEL NODE STUFF
# ------------------------
func _ready() -> void:
	connect_signals()
	ui.update_turn_count(current_turn_count, turns_to_complete)

func connect_signals() -> void:
	ui.ui_play_button_pressed.connect(play)
	ui.ui_reset_button_pressed.connect(reset_level)
	ui.ui_building_button_pressed.connect(select_building)
	construction_manager.building_placed.connect(on_building_placed)

func reset_level() -> void:
	get_tree().reload_current_scene()

func _physics_process(delta: float) -> void:
	construction_manager.update_build_point(get_viewport().get_mouse_position())

func win_level() -> void:
	level_victory.emit()
	ui.show_win_screen()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://UI/MainMenu/main_menu.tscn")
# -----------------------------------


# PLAY BUTTON FUNCTIONS
# -----------------------------
func play() -> void:
	is_activation_phase = true
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
	match current_turn_type:
		TURN.ALLY:
			if villager_death_count == 0:
				increment_turn_count()
			else:
				reset_turn()
		TURN.ENEMY:
			if villager_death_count == villager_count:
				increment_turn_count()
			else:
				reset_turn()
	# must be last!
	is_activation_phase = false

func increment_turn_count() -> void:
	current_turn_count += 1
	ui.update_turn_count(current_turn_count, turns_to_complete)
	match current_turn_type:
		TURN.ALLY:
			current_turn_type = TURN.ENEMY
		TURN.ENEMY:
			current_turn_type = TURN.ALLY
	if current_turn_count == turns_to_complete:
		win_level()

func reset_turn() -> void: 
	print("FAILURE!")
	villager_death_count = 0
	for v in villager_list:
		v.reset()
	for e in enemy_list:
		e.reset()

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


# CONSTRUCTION MANAGER FUNCTIONS
# ---------------------------
func select_building(slot : int) -> void:
	if is_activation_phase:
		return
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
	selected_building_index = slot

func on_building_placed() -> void:
	match current_turn_type:
		TURN.ALLY:
			defence_building_list.remove_at(selected_building_index)
		TURN.ENEMY:
			enemy_building_list.remove_at(selected_building_index)
	construction_manager.unload_construct()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		construction_manager.build_loaded_construct()
# ------------------------------
