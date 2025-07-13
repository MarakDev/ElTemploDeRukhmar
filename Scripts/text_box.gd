extends CanvasLayer

const CHAR_READ_RATE = 0.05

@onready var textbox_containter = $TextboxContainer
@onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Asterisco
@onready var end_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Final
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Text

enum State{
	READY,
	READING,
	FINISHED
}

var current_state
var tween
var text_queue = []

func _ready():
	hide_textbox()
	

func _process(delta):
	
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				add_text()
				show_textbox()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1
				tween.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
				pass
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				end_symbol.text = ""
				label.text = ""
				change_state(State.READY)
				if text_queue.is_empty():
					hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_containter.hide()
	change_state(State.READY)
	
func show_textbox():
	start_symbol.text = "* "
	textbox_containter.show()
	
func add_text():
	var new_text = text_queue.pop_front()
	label.text = new_text
	
	change_state(State.READING)
	
	show_textbox()
	tween = get_tree().create_tween()
	tween.tween_property(label, "visible_ratio", 1, len(new_text) * CHAR_READ_RATE).from(0).finished
	tween.connect("finished", on_tween_finished)
	
func on_tween_finished():
	end_symbol.text = "v"
	change_state(State.FINISHED)
	
	#await get_tree().create_timer(3).timeout
	#change_state(State.READY)
	#if text_queue.is_empty():
		#hide_textbox()

func change_state(next_state):
	current_state = next_state
	
