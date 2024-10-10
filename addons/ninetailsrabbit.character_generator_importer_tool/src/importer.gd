@tool
extends Node

@export var button_Generate_Animations: String
@export var button_Clear_Animations: String

## When enabled, an animation player it's created for each animated sprite to use in animation trees for example
@export var create_animation_player: bool = true
## The path to an individual spritesheet to import and create the animations
@export_file("*.png") var character_spritesheet: String
## The folder where the tool will find all the valid spritesheets to create the animations
@export_dir var character_spritesheet_folder: String
## When this is defined, all the contents of this folder represent a body part and the tool will create the sprite frames as resources
@export_dir var input_folder_parts: String
## The output where the sprite frame resources will be generated divided by body part
@export_dir var output_folder_parts: String
@export_group("Parameters")
## If this property it's enabled, the rest are ignored in the creation process
@export var auto_detect_sprite_size: bool = true
@export var sprite_size: SpriteSizes = SpriteSizes.Size16x16
@export var character_type: CharacterType = CharacterType.Adult
@export var animation_fps: int = 7
@export_group("Adult Animations")
@export var idle: bool = true
@export var standing_horizontal: bool = true
@export var walk: bool = true
@export var walk_with_object: bool = true
@export var seated: bool = true
@export var sleeping_head: bool = true
@export var grab_and_drop_object: bool = true
@export var give_object: bool = true
@export var pickup: bool = true
@export var phone: bool = true
@export var reading: bool = true
@export var punch: bool = true
@export var punch_variant: bool = true
@export var hand_throw: bool = true
@export var pull_out_gun: bool = true
@export var gun_idle: bool = true
@export var gun_shoot: bool = true
@export var hurt: bool = true
@export_group("Kid animations")
@export var idle_kid: bool = true
@export var walk_kid: bool = true


enum SpriteSizes {
	Size16x16,
	Size32x32,
	Size48x48
}

enum CharacterType {
	Adult,
	Kid
}


var current_sprite_size: Vector2 = Vector2(16, 16)
var current_sprite_is_kid: bool = false

	
func detect_sprite_size(spritesheet: Texture2D) -> SpriteSizes:
	var spritesheet_size: Vector2 = spritesheet.get_size()
	
	if spritesheet_size.is_equal_approx(Vector2(384, 128)):
		current_sprite_is_kid = true
		return SpriteSizes.Size16x16
	elif spritesheet_size.is_equal_approx(Vector2(768, 256)):
		current_sprite_is_kid = true
		return SpriteSizes.Size32x32
	elif spritesheet_size.is_equal_approx(Vector2(1152, 384)):
		current_sprite_is_kid = true
		return SpriteSizes.Size48x48
	if spritesheet_size.is_equal_approx(Vector2(896, 640)):
		current_sprite_is_kid = false
		return SpriteSizes.Size16x16
	elif spritesheet_size.is_equal_approx(Vector2(1792, 1280)):
		current_sprite_is_kid = false
		return SpriteSizes.Size32x32
	elif spritesheet_size.is_equal_approx(Vector2(2688, 1920)):
		current_sprite_is_kid = false
		return SpriteSizes.Size48x48
	else:
		return SpriteSizes.Size32x32


func vector_from_sprite_size(sprite_size: SpriteSizes) -> Vector2:
	match sprite_size:
		SpriteSizes.Size16x16:
			return Vector2(16, 16)
		SpriteSizes.Size32x32:
			return Vector2(32, 32)
		SpriteSizes.Size48x48:
			return Vector2(48, 48)
			
		_:
			return Vector2(32, 32)


func create_spritesheets_parts_as_resources() -> void:
	var image_format_regex = RegEx.new()
	image_format_regex.compile(".png$")

	if DirAccess.dir_exists_absolute(input_folder_parts) and DirAccess.dir_exists_absolute(output_folder_parts):
		var spritesheets = PluginUtilities.get_files_recursive(input_folder_parts, image_format_regex)
		
		if spritesheets.is_empty():
			return
		
		PluginUtilities.remove_files_recursive(output_folder_parts)
		DirAccess.make_dir_absolute(output_folder_parts)
		
		DirAccess.make_dir_absolute("%s/Adult" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Adult/Accessories/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Accessories/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Accessories/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Adult/Bodies/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Bodies/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Bodies/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Adult/Eyes/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Eyes/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Eyes/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Adult/Hairstyles/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Hairstyles/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Hairstyles/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Adult/Outfits/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Outfits/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Adult/Outfits/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Kid/Bodies/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Bodies/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Bodies/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Kid/Eyes/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Eyes/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Eyes/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Kid/Hairstyles/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Hairstyles/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Hairstyles/48x48" % output_folder_parts)
		
		DirAccess.make_dir_recursive_absolute("%s/Kid/Outfits/16x16" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Outfits/32x32" % output_folder_parts)
		DirAccess.make_dir_absolute("%s/Kid/Outfits/48x48" % output_folder_parts)
		
		## Refresh the file editor to see the new directories in the filedock
		EditorInterface.get_resource_filesystem().scan()
		
		## We assume that each core has 2 threads
		var available_threads: int = OS.get_processor_count() * 2
		var spritesheet_chunks = PluginUtilities.chunk_array(spritesheets, ceil(spritesheets.size() / available_threads))
		
		for spritesheet_chunk: Array in spritesheet_chunks:
			var thread = Thread.new()
			thread.start(create_spritesheets_as_resources.bind(spritesheet_chunk))
			finish_thread.call_deferred(thread)

		EditorInterface.get_resource_filesystem().scan()
	

func finish_thread(thread: Thread) -> void:
	if thread.is_alive:
		thread.wait_to_finish()
		

func create_spritesheets_as_resources(spritesheets: Array = []) -> void:
	for spritesheet_path: String in spritesheets:
		var sprite_frames: SpriteFrames = create_sprite_frames(spritesheet_path)
		var filename: String = spritesheet_path.get_file().get_basename()
		sprite_frames.resource_name = filename.to_pascal_case()
		var image: CompressedTexture2D = ResourceLoader.load(spritesheet_path, "CompressedTexture2D", ResourceLoader.CACHE_MODE_IGNORE)
		
		var sprite_size = vector_from_sprite_size(detect_sprite_size(image))
		var sprite_size_as_text = "%sx%s" % [sprite_size.x, sprite_size.y]

		var output_path: String
		var character_type_folder: String = "%s/%s" % [output_folder_parts, "Kid" if filename.containsn("kid") else "Adult" ]
		var character_part: String

		if filename.containsn("body"):
			character_part = "Bodies"
		elif filename.containsn("accessory"):
			character_part = "Accessories"
		elif filename.containsn("eyes"):
			character_part = "Eyes"
		elif filename.containsn("hairstyle"):
			character_part = "Hairstyles"
		elif filename.containsn("outfit"):
			character_part = "Outfits"

		output_path = "%s/%s/%s/%s" % [character_type_folder, character_part, sprite_size_as_text, filename + ".tres"]

		var error = ResourceSaver.save(sprite_frames, output_path)
		
		if error != OK:
			push_error("CharacterCreatorToolImporter: The sprite frames %s could not be created in the path %s" % [filename, output_path])
			continue


func generate_animations() -> void:
	var image_format_regex = RegEx.new()
	image_format_regex.compile(".png$")

	if _character_spritesheets_are_valid():
		
		PluginUtilities.free_children(self)
		
		if not character_spritesheet.is_empty():
			var sprite_frames: SpriteFrames = create_sprite_frames(character_spritesheet)
			create_animated_sprite(character_spritesheet, sprite_frames)
			
		if not character_spritesheet_folder.is_empty():
			for spritesheet_path: String in PluginUtilities.get_files_recursive(character_spritesheet_folder, image_format_regex):
				var sprite_frames: SpriteFrames = create_sprite_frames(spritesheet_path)
				create_animated_sprite(spritesheet_path, sprite_frames)
				
		if create_animation_player:
			for animated_sprite: AnimatedSprite2D in PluginUtilities.find_nodes_of_type(self, AnimatedSprite2D.new()):
				create_animation_player_for(animated_sprite)
			
	create_spritesheets_parts_as_resources()


func create_sprite_frames(path: String) -> SpriteFrames:
		var image: CompressedTexture2D = ResourceLoader.load(path, "CompressedTexture2D", ResourceLoader.CACHE_MODE_IGNORE)
		var sprite_frames: SpriteFrames = SpriteFrames.new()
		sprite_frames.remove_animation("default")
		
		if auto_detect_sprite_size:
			sprite_size = detect_sprite_size(image)
		else:
			current_sprite_is_kid = character_type == CharacterType.Kid
		
		current_sprite_size = vector_from_sprite_size(sprite_size)
		
		if current_sprite_is_kid:
			_create_idle_kid_animation_frames(sprite_frames, image)
			_create_walk_kid_animation_frames(sprite_frames, image)
		else:
			_create_idle_animation_frames(sprite_frames, image)
			_create_walk_animation_frames(sprite_frames, image)
			_create_sleep_animation_frames(sprite_frames, image)
			_create_seated_animation_frames(sprite_frames, image)
			_create_standing_animation_frames(sprite_frames, image)
			_create_reading_animation_frames(sprite_frames, image)
			_create_phone_animation_frames(sprite_frames, image)
			_create_walk_with_object_animation_frames(sprite_frames, image)
			_create_give_object_animation_frames(sprite_frames, image)
			_create_grab_drop_object_animation_frames(sprite_frames, image)
			_create_pickup_animation_frames(sprite_frames, image)
			_create_punch_animation_frames(sprite_frames, image)
			_create_hand_throw_animation_frames(sprite_frames, image)
			_create_pull_out_gun_animation_frames(sprite_frames, image)
			_create_gun_idle_animation_frames(sprite_frames, image)
			_create_gun_shoot_animation_frames(sprite_frames, image)
			_create_hurt_animation_frames(sprite_frames, image)
		
		return sprite_frames
		
			
func create_animated_sprite(path: String, sprite_frames: SpriteFrames) -> void:
	var root_node: Node2D = Node2D.new()
	root_node.name = path.get_file().get_basename()
	add_child(root_node)
	root_node.owner = get_tree().edited_scene_root
	
	var target_animated_sprite = AnimatedSprite2D.new()
	target_animated_sprite.sprite_frames = sprite_frames
	target_animated_sprite.name = "AnimatedSprite2D"
	root_node.add_child(target_animated_sprite)
	target_animated_sprite.owner = get_tree().edited_scene_root
		

func create_animation_player_for(animated_sprite: AnimatedSprite2D):
	var animation_player: AnimationPlayer = AnimationPlayer.new()
	animation_player.name = "AnimationPlayer"
	animation_player.add_animation_library(&"", AnimationLibrary.new()) # Add global animation library (empty string)
	animated_sprite.get_parent().add_child(animation_player)
	
	animation_player.owner = get_tree().edited_scene_root
	var global_animation_library = animation_player.get_animation_library(&"")

	var target_sprite_frames: SpriteFrames = animated_sprite.sprite_frames
	
	if not target_sprite_frames:
		push_error("CharacterCreatorToolImporter: The animated sprite %s has no sprite frames" % animated_sprite.name)
		return
	
	for animation_name: String in target_sprite_frames.get_animation_names():
		if not animation_name.is_empty():
			var animation: Animation =  Animation.new()
			var frame_count = target_sprite_frames.get_frame_count(animation_name)
			var fps = target_sprite_frames.get_animation_speed(animation_name)
			var looping = target_sprite_frames.get_animation_loop(animation_name)
			var duration: float = 0
			
			for i in range(frame_count):
				duration += target_sprite_frames.get_frame_duration(animation_name, i)
				
			duration /= fps
			
			var spf = 1 / fps
			animation.resource_name = animation_name
			animation.length = snappedf(duration, 0.01)
			animation.loop_mode = Animation.LOOP_LINEAR if looping else Animation.LOOP_NONE
			
			var animation_name_path: String = "%s:animation" % animated_sprite.name 
			var frame_path: String = "%s:frame" % animated_sprite.name
			
			var frame_track = animation.add_track(Animation.TYPE_VALUE, 0)
			var anim_track = animation.add_track(Animation.TYPE_VALUE, 1)
			
			animation.track_set_path(anim_track, animation_name_path)
			animation.track_insert_key(anim_track, 0, animation_name)
			animation.track_set_path(frame_track, frame_path)
			animation.track_set_interpolation_loop_wrap(anim_track, false)
			
			animation.value_track_set_update_mode(frame_track, Animation.UPDATE_DISCRETE)
			animation.value_track_set_update_mode(anim_track, Animation.UPDATE_DISCRETE)
			
			var next_key_time: float = 0.0

			for i in range(frame_count):
				animation.track_insert_key(frame_track, next_key_time, i)
				var frame_duration_multiplier = target_sprite_frames.get_frame_duration(animation_name, i)
				next_key_time += frame_duration_multiplier * spf

			global_animation_library.add_animation(animation_name, animation)		


func _create_idle_kid_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if idle_kid:
		var frame_data = _get_frame_data_based_on_size("idle_kid", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var idle := {
			"right": {"number_of_frames": 6},
			"up": {"number_of_frames": 6},
			"left": {"number_of_frames": 6},
			"down": {"number_of_frames": 6},
		}
			
		var index := 0
		
		for direction in idle.keys():
			var animation_name = "idle_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(idle[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_walk_kid_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if idle_kid:	
		var frame_data = _get_frame_data_based_on_size("walk_kid", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var walk := {
			"right": {"number_of_frames": 6},
			"up": {"number_of_frames": 6},
			"left": {"number_of_frames": 6},
			"down": {"number_of_frames": 6},
		}
			
		var index := 0
		
		for direction in walk.keys():
			var animation_name = "walk_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(walk[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_gun_idle_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if gun_idle:
		var frame_data = _get_frame_data_based_on_size("gun_idle", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var gun_idle := {
			"right": {"number_of_frames": 6},
			"up": {"number_of_frames": 6},
			"left": {"number_of_frames": 6},
			"down": {"number_of_frames": 6},
		}
			
		var index := 0
		
		for direction in gun_idle.keys():
			var animation_name = "gun_idle_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(gun_idle[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_gun_shoot_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if gun_shoot:
		var frame_data = _get_frame_data_based_on_size("gun_shoot", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var gun_shoot := {
			"right": {"number_of_frames": 3, "last_frame": {"animation": "gun_idle", "index": 0}},
			"up": {"number_of_frames": 3,  "last_frame": {"animation": "gun_idle", "index": 6}},
			"left": {"number_of_frames": 3,  "last_frame": {"animation": "gun_idle", "index": 12}},
			"down": {"number_of_frames": 3,  "last_frame": {"animation": "gun_idle", "index": 18}},
		}
			
		var index := 0
		
		for direction in gun_shoot.keys():
			var animation_name = "gun_shoot_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			## We create an extra frame from gun idle so as not to need to return to idle after this animation
			var last_frame_data = _get_frame_data_based_on_size(gun_shoot[direction].last_frame.animation, sprite_size)
			var last_frame_index = gun_shoot[direction].last_frame.index
			_create_frame(sprite_frames, image, animation_name, last_frame_index, last_frame_data.position, last_frame_data.size, frame_duration, frame_data.loopable)
			
			for _i in range(gun_shoot[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1
			
			_create_frame(sprite_frames, image, animation_name, last_frame_index, last_frame_data.position, last_frame_data.size, frame_duration, frame_data.loopable)


func _create_pull_out_gun_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if pull_out_gun:	
		var frame_data = _get_frame_data_based_on_size("pull_out_gun", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var pull_out_gun := {
			"right": {"number_of_frames": 4},
			"up": {"number_of_frames": 4},
			"left": {"number_of_frames": 4},
			"down": {"number_of_frames": 4},
		}
			
		var index := 0
		
		for direction in pull_out_gun.keys():
			var animation_name = "pull_out_gun_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(pull_out_gun[direction].number_of_frames):
				if index not in [3, 7, 11, 15]:
					_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1

		
func _create_punch_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if punch:	
		var frame_data = _get_frame_data_based_on_size("punch", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var punch := {
			"right": {"number_of_frames": 6},
			"up": {"number_of_frames": 6},
			"left": {"number_of_frames": 6},
			"down": {"number_of_frames": 6},
		}
			
		var index := 0
		
		for direction in punch.keys():
			var animation_name = "punch_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(punch[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_punch_variant_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if punch_variant:	
		var frame_data = _get_frame_data_based_on_size("punch_variant", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var punch_variant := {
			"right": {"number_of_frames": 6},
			"up": {"number_of_frames": 6},
			"left": {"number_of_frames": 6},
			"down": {"number_of_frames": 6},
		}
			
		var index := 0
		
		for direction in punch_variant.keys():
			var animation_name = "punch_variant_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(punch_variant[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1



func _create_hand_throw_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if hand_throw:	
		var frame_data = _get_frame_data_based_on_size("hand_throw", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var hand_throw := {
			"right": {"number_of_frames": 6},
			"up": {"number_of_frames": 6},
			"left": {"number_of_frames": 6},
			"down": {"number_of_frames": 6},
		}
			
		var index := 0
		
		for direction in hand_throw.keys():
			var animation_name = "hand_throw_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(hand_throw[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_hurt_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if hurt:	
		var frame_data = _get_frame_data_based_on_size("hurt", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var hurt := {
			"right": {"number_of_frames": 3},
			"up": {"number_of_frames": 3},
			"left": {"number_of_frames": 3},
			"down": {"number_of_frames": 3},
		}
			
		var index := 0
		
		for direction in hurt.keys():
			var animation_name = "hurt_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(hurt[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_grab_drop_object_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):	
	if grab_and_drop_object:
		var frame_data = _get_frame_data_based_on_size("grab_object", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var grab_object := {
			"right": {"grab": {"number_of_frames": 8}, "drop": {"number_of_frames": 6}},
			"up": {"grab": {"number_of_frames": 8}, "drop": {"number_of_frames": 6}},
			"left": {"grab": {"number_of_frames": 8}, "drop": {"number_of_frames": 6}},
			"down": {"grab": {"number_of_frames": 8}, "drop": {"number_of_frames": 6}},
		}
			
		var index := 0
		
		for direction in grab_object.keys():
			for action in grab_object[direction].keys():
				var animation_name = "%s_object_%s" % [action, direction]
				sprite_frames.add_animation(animation_name)
				
				for _i in range(grab_object[direction][action].number_of_frames):
					_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
					index += 1



func _create_give_object_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):	
	if give_object:
		var frame_data = _get_frame_data_based_on_size("give_object", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var give_object := {
			"right": {"number_of_frames": 10},
			"up": {"number_of_frames": 10},
			"left": {"number_of_frames": 10},
			"down": {"number_of_frames": 10},
		}
			
		var index := 0
		
		for animation in give_object.keys():
			var animation_name = "give_object_%s" % animation
			sprite_frames.add_animation(animation_name)
			
			for _i in range(give_object[animation].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_pickup_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):	
	if pickup:
		var frame_data = _get_frame_data_based_on_size("pickup", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var pickup := {
			"right": {"number_of_frames": 12},
			"up": {"number_of_frames": 12},
			"left": {"number_of_frames": 12},
			"down": {"number_of_frames": 12},
		}
			
		var index := 0
		
		for direction in pickup.keys():
			var animation_name = "pickup_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(pickup[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_walk_with_object_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):	
	if walk_with_object:
		var frame_data = _get_frame_data_based_on_size("walk_with_object", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var walk_object := {
			"right": {"number_of_frames": 6},
			"up": {"number_of_frames": 6},
			"left": {"number_of_frames": 6},
			"down": {"number_of_frames": 6},
		}
			
		var index := 0
		
		for direction in walk_object.keys():
			var animation_name = "walk_with_object_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(walk_object[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_phone_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):	
	if phone:
		var frame_data = _get_frame_data_based_on_size("phone", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var phone_animations := {
			"pull_out": {"number_of_frames": 5, "loopable": false},
			"idle": {"number_of_frames": 2, "loopable": true},
			"save": {"number_of_frames": 5, "loopable": false, "last_frame": {"animation": "idle", "index": 19}}
		}
		
		var index := 0
		
		for animation in phone_animations.keys():
			var animation_name = "phone_%s" % animation
			sprite_frames.add_animation(animation_name)
			
			if animation_name == "phone_idle":
				sprite_frames.add_animation("phone_idle_static")
				_create_frame(sprite_frames, image, "phone_idle_static", index, frame_position, frame_size, frame_duration, phone_animations[animation].loopable)
				
			for _i in range(phone_animations[animation].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, phone_animations[animation].loopable)
				index += 1
			
			if animation_name == "phone_save":
				var last_frame_data = _get_frame_data_based_on_size(phone_animations[animation].last_frame.animation, sprite_size)
				var last_frame_index = phone_animations[animation].last_frame.index
				_create_frame(sprite_frames, image, animation_name, last_frame_index, last_frame_data.position, last_frame_data.size, frame_duration,  phone_animations[animation].loopable)
			


func _create_reading_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if reading:
		var animation_name = "reading"
		
		var frame_data = _get_frame_data_based_on_size(animation_name, sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var number_of_frames := 12
		
		sprite_frames.add_animation(animation_name)
		
		for index in range(number_of_frames):
			_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
			
			
func _create_standing_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):	
	if standing_horizontal:
		var frame_data = _get_frame_data_based_on_size("standing", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var standing := {
			"right": {"number_of_frames": 6},
			"left": {"number_of_frames": 6}
		}
		
		var index := 0
		
		for direction in standing.keys():
			var animation_name = "standing_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(standing[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_seated_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):	
	if seated:
		var frame_data = _get_frame_data_based_on_size("seated", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var seated := {
			"right": {"number_of_frames": 6},
			"left": {"number_of_frames": 6}
		}
		
		var index := 0
		
		for direction in seated.keys():
			var animation_name = "seated_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(seated[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_sleep_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if sleeping_head:
		var animation_name = "sleeping_head"
		
		var frame_data = _get_frame_data_based_on_size(animation_name, sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var number_of_frames := 6
		
		sprite_frames.add_animation(animation_name)
		
		for index in range(number_of_frames):
			_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)


func _create_walk_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if walk:
		var frame_data = _get_frame_data_based_on_size("walk", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var walk := {
				"right": {"number_of_frames": 6},
				"up": {"number_of_frames": 6},
				"left": {"number_of_frames": 6},
				"down": {"number_of_frames": 6},
			}
		
		var index := 0
		
		for direction in walk.keys():
			var animation_name = "walk_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(walk[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_idle_animation_frames(sprite_frames: SpriteFrames, image: CompressedTexture2D):
	if idle:
		var frame_data = _get_frame_data_based_on_size("idle", sprite_size)
		var frame_position = frame_data.position
		var frame_size = frame_data.size
		var frame_duration := 1.0
		
		var idle := {
				"right": {"number_of_frames": 6},
				"up": {"number_of_frames": 6},
				"left": {"number_of_frames": 6},
				"down": {"number_of_frames": 6},
			}
		
		var index := 0 # The index is sum on all iterations to keep increasing right.x in this specific spritesheet line
		
		for direction in idle.keys():
			var animation_name = "idle_%s" % direction
			sprite_frames.add_animation(animation_name)
			
			for _i in range(idle[direction].number_of_frames):
				_create_frame(sprite_frames, image, animation_name, index, frame_position, frame_size, frame_duration, frame_data.loopable)
				index += 1


func _create_atlas_texture_from_frame(region: Rect2, image: CompressedTexture2D) -> AtlasTexture:
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = image
	atlas_texture.region = region
	
	return atlas_texture


func _create_frame(
	sprite_frames: SpriteFrames,
	image: CompressedTexture2D,
	animation_name: String,
	index: int,
	frame_position: Vector2,
	frame_size: Vector2,
	frame_duration: float = 1.0, 
	loopable: bool = true
	):
	var region = Rect2(Vector2(frame_position.x + current_sprite_size.x * index, frame_position.y), frame_size)
	
	sprite_frames.add_frame(animation_name, _create_atlas_texture_from_frame(region, image), frame_duration)
	sprite_frames.set_animation_loop(animation_name, loopable)
	sprite_frames.set_animation_speed(animation_name, animation_fps)
	
	
func _get_frame_data_based_on_size(animation: String, sprite_size: SpriteSizes) -> Dictionary:
	const size_16_default := Vector2(16, 32)
	const size_32_default := Vector2(32, 64)
	const size_48_default := Vector2(48, 96)
	
	const size_16_kid_default := Vector2(16, 24)
	const size_32_kid_default := Vector2(32, 48)
	const size_48_kid_default := Vector2(48, 64)
	
	match animation:
		"idle_kid":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 40), "size": size_16_kid_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 80), "size": size_32_kid_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 128), "size": size_48_kid_default, "loopable": true}		
		"walk_kid":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 72), "size": size_16_kid_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 144), "size": size_32_kid_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 224), "size": size_48_kid_default, "loopable": true}
		"idle":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 32), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 64), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 96), "size": size_48_default, "loopable": true}
		"walk":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 64), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 128), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 192), "size": size_48_default, "loopable": true}
		"sleeping_head":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 96), "size": Vector2(16, 24), "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 200), "size": Vector2(32, 32), "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 296), "size": Vector2(48, 56), "loopable": true}
		"seated":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 128), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 256), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 384), "size": size_48_default, "loopable": true}
		"standing":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 160), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 320), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 480), "size": size_48_default, "loopable": true}
		"reading":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 224), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 448), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 672), "size": size_48_default, "loopable": true}
		"phone":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 192), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 384), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 476), "size": size_48_default, "loopable": true}
		"walk_with_object":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 256), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 512), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 768), "size": size_48_default, "loopable": true}
		"give_object":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 320), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 640), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 960), "size": size_48_default, "loopable": false}
		"grab_object":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 352), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 704), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1056), "size": size_48_default, "loopable": false}		
		"pickup":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 288), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 576), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 864), "size": size_48_default, "loopable": false}	
		"hand_throw":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 416), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 832), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1248), "size": size_48_default, "loopable": false}
		"punch":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 448), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 896), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1340), "size": size_48_default, "loopable": false}
		"punch_variant":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 480), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 960), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1440), "size": size_48_default, "loopable": false}
		"pull_out_gun":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 512), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 1024), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1536), "size": size_48_default, "loopable": false}
					
		"gun_idle":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 544), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 1088), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1632), "size": size_48_default, "loopable": true}
		"gun_shoot":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 576), "size": size_16_default, "loopable": false}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 1152), "size": size_32_default, "loopable": false} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1728), "size": size_48_default, "loopable": false}
		"hurt":
			match sprite_size:
				SpriteSizes.Size16x16:
					return {"position": Vector2(0, 608), "size": size_16_default, "loopable": true}
				SpriteSizes.Size32x32:
					return {"position": Vector2(0, 1216), "size": size_32_default, "loopable": true} 
				SpriteSizes.Size48x48:
					return {"position": Vector2(0, 1818), "size": size_48_default, "loopable": true}
	return {}


#region Private and helper functions
func _character_spritesheets_are_valid() -> bool:
	if character_spritesheet.is_empty():
		push_warning("CharacterCreatorToolImporter: The character spritesheet file is empty, select a valid spritesheet to generate the animations")
	
	if character_spritesheet_folder.is_empty():
		push_warning("CharacterCreatorToolImporter: The character spritesheet folder is empty, select a folder with the spritesheet files to generate the animations")
	
	if character_spritesheet.is_empty() and character_spritesheet_folder.is_empty():
		return false
	
	return true
	
	
func _on_tool_button_pressed(text: String) -> void:
	match text:
		"Generate Animations":
			generate_animations()
		"Clear Animations":
			PluginUtilities.free_children(self)
#endregion
