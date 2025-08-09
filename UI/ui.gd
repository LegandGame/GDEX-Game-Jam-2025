extends CanvasLayer

# NODE References
@onready var play_button : Button = %PlayButton
@onready var reset_button : Button = %ResetButton
@onready var description_label : Label = %DescriptionLabel
@onready var turns_label : Label = %TurnsLabel

@onready var victory_panel := $YouWinPanel

@onready var b1 : Button = %Building1Button
@onready var b2 : Button = %Building2Button
@onready var b3 : Button = %Building3Button
@onready var b4 : Button = %Building4Button
@onready var b5 : Button = %Building5Button
@onready var b6 : Button = %Building6Button
@onready var b7 : Button = %Building7Button
@onready var b8 : Button = %Building8Button
@onready var b9 : Button = %Building9Button

# signals
signal ui_play_button_pressed
signal ui_reset_button_pressed
signal ui_building_button_pressed(number)

func _ready() -> void:
	play_button.pressed.connect(play_button_pressed)
	reset_button.pressed.connect(reset_button_pressed)
	victory_panel.hide()
	
	# the fuckery
	b1.pressed.connect(bp1)
	b2.pressed.connect(bp2)
	b3.pressed.connect(bp3)
	b4.pressed.connect(bp4)
	b5.pressed.connect(bp5)
	b6.pressed.connect(bp6)
	b7.pressed.connect(bp7)
	b8.pressed.connect(bp8)
	b9.pressed.connect(bp9)

func play_button_pressed() -> void:
	ui_play_button_pressed.emit()

func reset_button_pressed() -> void:
	ui_reset_button_pressed.emit()

func show_win_screen() -> void:
	$YouWinPanel.show()

func update_turn_count(current_turn : int, total_turn : int) -> void:
	var new_string = "Turns: %d/%d"
	new_string = new_string % [current_turn, total_turn]
	turns_label.text = new_string

# the fuckery part 2
func bp1() -> void:
	ui_building_button_pressed.emit(0)
func bp2() -> void:
	ui_building_button_pressed.emit(1)
func bp3() -> void:
	ui_building_button_pressed.emit(2)
func bp4() -> void:
	ui_building_button_pressed.emit(3)
func bp5() -> void:
	ui_building_button_pressed.emit(4)
func bp6() -> void:
	ui_building_button_pressed.emit(5)
func bp7() -> void:
	ui_building_button_pressed.emit(6)
func bp8() -> void:
	ui_building_button_pressed.emit(7)
func bp9() -> void:
	ui_building_button_pressed.emit(8)
