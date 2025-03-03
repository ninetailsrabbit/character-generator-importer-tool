@tool
extends EditorPlugin

var inspector_plugin
var plugin_custom_type: String = "CharacterGeneratorToolImporter"


func _enter_tree() -> void:
	add_custom_type(plugin_custom_type, "Node", preload("src/importer.gd"), preload("assets/character-generator-importer-tool.svg"))
	
	inspector_plugin = preload("inspector/inspector_button_plugin.gd").new()
	add_inspector_plugin(inspector_plugin)
	

func _exit_tree() -> void:
	remove_custom_type(plugin_custom_type)
	remove_inspector_plugin(inspector_plugin)


func _get_plugin_name() -> String:
	return "Character Generator Tool Importer"
