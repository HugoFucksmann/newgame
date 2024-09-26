extends Control

signal power_selected(power)

@onready var power_buttons = [$PowerButton1, $PowerButton2, $PowerButton3]

func display_powers(powers: Array):
	for i in range(3):
		if i < powers.size():
			power_buttons[i].text = powers[i].name + "\n" + powers[i].get_description()
			power_buttons[i].set_meta("power", powers[i])
			power_buttons[i].show()
		else:
			power_buttons[i].hide()

func _on_power_button_pressed(button):
	var selected_power = button.get_meta("power")
	emit_signal("power_selected", selected_power)
