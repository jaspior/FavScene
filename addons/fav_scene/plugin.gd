tool
extends EditorPlugin

const ImportScenes = preload("res://addons/fav_scene/ImportScenes.tscn")

var import_instance

var _selected_scene

var _editing_object

var config = ConfigFile.new()
const CONFIG_FILE = "res://settings.cfg"


var settings = {
		"Buttons":{
			"Buttons":null
			}
	}

var default_settings = {
	
		"Buttons":{
			"Buttons": []
		}
	
	}

func make_default_config():
	config.save(CONFIG_FILE)


func load_settings():
	var error = config.load(CONFIG_FILE)
	if error != OK:
		make_default_config()
	for section in settings.keys():
		for key in settings[section]:
			settings[section][key] = config.get_value(section, key, default_settings[section][key])
	save_settings()
	
func save_settings():
	for section in settings.keys():
		for key in settings[section]:
			config.set_value(section, key, settings[section][key])
	config.save(CONFIG_FILE)


func handles(object):
	return object is CanvasItem

func edit(object):
	_editing_object = object
	print(_editing_object)


func _init():
	load_settings()

func _enter_tree():
	import_instance = ImportScenes.instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, import_instance)
	import_instance.get_node("ScrollContainer/VBoxContainer/HBoxContainer/Button").connect("pressed",self,"_on_button_pressed")
	import_instance.get_node("FileDialog").connect("file_selected",self,"_scene_selected")
	import_instance.get_node("ScrollContainer/VBoxContainer/HBoxContainer/Save").connect("pressed",self,"_save_config")
	import_instance.get_node("ScrollContainer/VBoxContainer/HBoxContainer/Clear").connect("pressed",self,"_clear_config")
	
	if settings.Buttons.Buttons.size() > 0:
		for i in settings.Buttons.Buttons.size():
			_scene_selected(settings.Buttons.Buttons[i])

func _clear_config():
	import_instance.FavScenes = []
	for child in import_instance.get_node("ScrollContainer/VBoxContainer/GridContainer").get_children():
		child.queue_free()

func _save_config():
	settings.Buttons.Buttons = import_instance.FavScenes
	save_settings()

func _on_button_pressed():
	import_instance.get_node("FileDialog").popup_centered()


func _scene_selected(path):
	
	import_instance.FavScenes.append(path)
	var resource_previewer := get_editor_interface().get_resource_previewer()

	resource_previewer.queue_resource_preview(path, self, "_on_resource_preview", null)


func _on_resource_preview(path:String, texture:Texture, user_data) -> void:
	if import_instance and texture:
		var button := Button.new()
		button.icon = texture
		var name_button = path.replace("res://","").replace(".tscn","")
		button.text = name_button
		button.rect_min_size = Vector2(32, 32)
		button.connect("pressed", self, "_on_scene_pressed", [path])
		import_instance.get_node("ScrollContainer/VBoxContainer/GridContainer").add_child(button)
		
			
func _on_scene_pressed(path:String) -> void:
	print(path)
	_selected_scene = path
	


func _exit_tree():
	if import_instance:
		remove_control_from_docks(import_instance)
		import_instance.queue_free()
		
	

func forward_canvas_gui_input(event:InputEvent) -> bool:

	if not _editing_object:
		return false

	if not event is InputEventMouseButton:
		return false
		
	if not event.pressed or not event.button_index == 2:
		return false
		
			
	var new_instance_resource := load(_selected_scene)
	if not new_instance_resource:
		return false
			
	var new_instance = new_instance_resource.instance()
	if not new_instance:
		return false
			
		
	var undo := get_undo_redo()
	undo.create_action("paint_scene")
	undo.add_do_method(self, "paint_scene_", new_instance,_editing_object, _editing_object.get_global_mouse_position())
	undo.add_undo_method(self, "undo_paint_scene_", new_instance, _editing_object)
		
		# docs say this will prevent leaking newly created node though never verified personally
		
	undo.add_do_reference(new_instance)
	undo.commit_action()
		
	# stop godot selecting newly added node
	get_editor_interface().call_deferred("edit_node", _editing_object)
		
	return true


func paint_scene_(scene:Node, pallet:Node, position:Vector2) -> void:
	scene.global_position = position
	# without this, node will be added but NOT to the scene tree so won't be saved
	pallet.add_child(scene)
	scene.owner = pallet
	print(pallet)

func undo_paint_scene_(scene:Node, pallet:Node) -> void:
	pallet.remove_child(scene)
	# no queue_free as we may redo action
