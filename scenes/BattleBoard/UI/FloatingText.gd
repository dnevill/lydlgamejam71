extends Node2D
class_name FloatText

const BASE_FONT_SIZE = 64



# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -200.0, 2).as_relative()
	tween.parallel().tween_property(self,'modulate:a',0.0,2	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)
	var my_personal_setings = LabelSettings.new()
	var original_settings = $Label.label_settings
	my_personal_setings.font = original_settings.font
	my_personal_setings.font_color = original_settings.font_color
	my_personal_setings.font_size = original_settings.font_size
	my_personal_setings.outline_color = original_settings.outline_color
	my_personal_setings.outline_size = original_settings.outline_size
	my_personal_setings.shadow_color = original_settings.shadow_color
	my_personal_setings.shadow_offset = original_settings.shadow_offset
	my_personal_setings.shadow_size = original_settings.shadow_size
	$Label.label_settings = my_personal_setings
	

func damage(value : int):
	$Label/heartRect.visible = true
	_config_label(
		str(value),
		Color(1.0, 0.0, 0.0, 1.0),
		BASE_FONT_SIZE + value
	)

func heal(value : int):
	$Label/heartRect.visible = true
	_config_label(
		str(value),
		Color(0.0, 1.0, 0.0, 1.0),
		BASE_FONT_SIZE + value
	)

func flies(value : int):
	$Label/flyRect.visible = true
	var color = Color(0.0, 0.0, 1.0, 1.0)
	if value < 0:
		color = Color(0.6, 0.0, 0.6, 1.0)
	_config_label(
		str(value),
		color,
		BASE_FONT_SIZE + value
	)

func _config_label(text : String, color : Color, font_size : int):
	$Label.text = text
	$Label.label_settings.font_color = color
	$Label.label_settings.font_size = font_size
