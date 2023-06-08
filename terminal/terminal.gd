extends HFlowContainer
class_name Terminal

@export_category("Terminal")
@export_enum("A: ", "> ", "$ ", "# ") var PROMPT: String = "A: "

@onready var history: PackedStringArray = []
@onready var currentLine: LineEdit = $Line


func new_line():
	currentLine.disconnect("text_changed", _on_text_changed)
	history.append(currentLine.text.substr(PROMPT.length()))

	if get_child_count() == 17: remove_child(get_child(0))

	add_child(currentLine.duplicate(), true)
	currentLine = get_child(get_child_count() - 1)
	currentLine.connect("text_changed", _on_text_changed)
	currentLine.text = PROMPT
	currentLine.grab_focus()

func _ready() -> void:
	currentLine.connect("text_changed", _on_text_changed)
	currentLine.text = PROMPT
	currentLine.grab_focus()

func _process(_delta: float) -> void:
	if currentLine.caret_column < PROMPT.length():
		currentLine.caret_column = PROMPT.length()

func _input(_event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_ENTER) or Input.is_key_pressed(KEY_KP_ENTER):
		new_line()

func _on_text_changed(new_text: String):
	var gutterCheck = new_text.substr(0, PROMPT.length())
	if gutterCheck.is_empty():
		currentLine.text = PROMPT + currentLine.text
	elif gutterCheck != PROMPT:
		currentLine.text = PROMPT + currentLine.text.substr(PROMPT.length() - 1)
