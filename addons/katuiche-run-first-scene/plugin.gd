tool
extends EditorPlugin
const SHORTCUT_CONFIGURATION = 'editor_plugins/katuiche/run_first_scene_shortcut'

var _keys = []
var _popup = null

func _enter_tree() -> void:
    var settings = get_editor_interface().get_editor_settings()
    if not settings.has_setting(SHORTCUT_CONFIGURATION):
        settings.set_setting(SHORTCUT_CONFIGURATION, str(KEY_CONTROL) + '+' + str(KEY_F6))
    _load_keys()
    add_tool_menu_item("Configure Katuiche Run First Scene shortcut", self, '_on_configure')

func enable_plugin():
    print('Thanks for using "Run First Scene"! :D')
    print("Katuiche Run First Scene configuration avaliable at project/tools")

func _exit_tree() -> void:
    remove_tool_menu_item("Configure Katuiche Run First Scene shortcut")

func _load_keys():
    _keys = []
    var settings = get_editor_interface().get_editor_settings()
    for key in settings.get_setting(SHORTCUT_CONFIGURATION).split("+"):
        _keys.append(int(key))

func _on_configure(args):
    _popup = preload("./configuration/configuration.tscn").instance()
    _popup.connect("keys_set", self, "_on_keys_set")
    get_parent().add_child(_popup)
    _popup.popup_centered()

func _on_keys_set(keys):
    _keys = keys
    var setting = ""
    for key in keys:
        setting += str(key) + "+"
    setting.erase(setting.length() - 1, 1)
    var settings = get_editor_interface().get_editor_settings()
    settings.set_setting(SHORTCUT_CONFIGURATION, setting)
    _popup = null

func _input(event):
    if _keys.empty():
        return
    if _popup != null:
        return
    var just_pressed = event.is_pressed() and not event.is_echo()
    if not just_pressed:
        return
    for key in _keys:
        if not Input.is_key_pressed(key):
            return
    _run_first_scene()

func _run_first_scene():
    var interface := get_editor_interface()
    if interface.is_playing_scene():
        interface.stop_playing_scene()
    var scenes = interface.get_open_scenes()
    if not scenes.empty():
        interface.play_custom_scene(scenes[0])
