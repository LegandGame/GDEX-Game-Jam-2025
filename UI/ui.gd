extends CanvasLayer

# NODE References
@onready var play_button : Button = %PlayButton
@onready var reset_button : Button = %ResetButton
@onready var description_label : Label = %DescriptionLabel
@onready var turns_label : Label = %TurnsLabel

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

func play_button_pressed() -> void:
	ui_play_button_pressed.emit()

func reset_button_pressed() -> void:
	ui_reset_button_pressed

func update_turn_count(current_turn : int, total_turn : int) -> void:
	var new_string = "Turns: %d/%d"
	new_string = new_string % [current_turn, total_turn]
	turns_label.text = new_string
