class_name CharacterGeneratorImporterToolPluginUtilities


## Supports RegEx expressions
static func get_files_recursive(path: String, regex: RegEx = null) -> Array:
	if path.is_empty() or not DirAccess.dir_exists_absolute(path):
		return []
		
	var files = []
	var directory = DirAccess.open(path)
	
	if directory:
		directory.list_dir_begin()
		var file := directory.get_next()
		
		while file != "":
			if directory.current_is_dir():
				files += get_files_recursive(directory.get_current_dir().path_join(file), regex)
			else:
				var file_path = directory.get_current_dir().path_join(file)
				
				if regex != null:
					if regex.search(file_path):
						files.append(file_path)
				else:
					files.append(file_path)
					
			file = directory.get_next()
			
		return files
	else:
		push_error("PluginUtilities->get_files_recursive: An error %s occured when trying to open directory: %s" % [DirAccess.get_open_error(), path])
		
		return []


static func remove_files_recursive(path: String, regex: RegEx = null) -> void:
	var directory = DirAccess.open(path)
	
	if DirAccess.get_open_error() == OK:
		directory.list_dir_begin()
		
		var file_name = directory.get_next()
		
		while file_name != "":
			if directory.current_is_dir():
				remove_files_recursive(directory.get_current_dir().path_join(file_name), regex)
			else:
				if regex != null:
					if regex.search(file_name):
						directory.remove(file_name)
				else:
					directory.remove(file_name)
					
			file_name = directory.get_next()
		
		directory.remove(path)
	else:
		push_error("PluginUtilities->remove_recursive: An error %s happened open directory: %s " % [DirAccess.get_open_error(), path])


static func find_nodes_of_type(node: Node, type_to_find: Node) -> Array:
	var  result := []
	
	var childrens = node.get_children(true)

	for child in childrens:
		if child.is_class(type_to_find.get_class()):
			result.append(child)
		else:
			result.append_array(find_nodes_of_type(child, type_to_find))
	
	return result


static func free_children(node: Node, except: Array = []) -> void:
	if node.get_child_count() == 0:
		return

	var childrens = node.get_children().filter(func(child): return not child.get_class() in except)
	childrens.reverse()
	
	for child in childrens:
		child.free()
	
	except.clear()


static func chunk_array(array: Array, size: int):
	var result = []
	var i = 0
	var j = -1
	
	for element in array:
		if i % size == 0:
			result.push_back([])
			j += 1
			
		result[j].push_back(element)
		i += 1
		
	return result
