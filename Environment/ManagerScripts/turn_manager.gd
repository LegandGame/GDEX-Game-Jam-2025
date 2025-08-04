extends Node

enum TURN{ALLY, ACTIVATION, ENEMY}
var current_turn : TURN = TURN.ALLY

var villager_list : Array
var villager_count : int
var villager_death_count : int = 0

var enemy_list : Array

func activation_phase() -> void:
	# get villager list
	if !villager_list:
		lazy_init_villager_list()
	enemy_list = get_tree().get_nodes_in_group("Enemy")
	for e in enemy_list:
		e.activate()
		await e.enemy_complete
	

func lazy_init_villager_list() -> void:
	villager_list = get_tree().get_nodes_in_group("Villager")
	villager_count = villager_list.size()
	for v in villager_list:
		v.villager_died.connect(increment_villager_death_count)

func increment_villager_death_count() -> void:
	villager_death_count += 1

# DEBUG
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		activation_phase()
