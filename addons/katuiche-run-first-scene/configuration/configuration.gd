tool
extends WindowDialog

var _progress := 0.0
var _pressed_keys := []
var _set := false

signal keys_set(keys)

onready var _progress_bar := $ProgressBar
onready var _pressed_keys_label := $PressedKeys
onready var _accept_dialog := $AcceptDialog

func _process(delta: float) -> void:
    if _set:
        return
    _progress_bar.value = _progress
    if not _pressed_keys.empty():
        _progress += 5 * delta
        _progress = lerp(_progress, 100, 1 * delta)
    if _progress > 100:
        _set = true
        _accept_dialog.popup_centered()

func _update_pressed_keys():
    _pressed_keys_label.text = ""
    for key in _pressed_keys:
        _pressed_keys_label.text += OS.get_scancode_string(key) + " "

func _input(event: InputEvent) -> void:
    if _set:
        return
    if not event is InputEventKey:
        return
    if event.is_echo():
        return
    _progress = 0
    if not event.is_pressed():
        _pressed_keys.erase(event.scancode)
    else:
        _pressed_keys.append(event.scancode)
    _update_pressed_keys()


func _on_SandwichRunFirstSceneConfiguration_popup_hide() -> void:
    queue_free()


func _on_AcceptDialog_confirmed() -> void:
    emit_signal('keys_set', _pressed_keys)
    hide()
