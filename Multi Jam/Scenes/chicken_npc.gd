extends Node2D


@onready var tile_map = get_node("../TileMap")
@onready var sprite = get_node("AnimatedSprite2D")

var current_dir = "none"
var is_moving = false
	
func _ready():
	current_dir = "down" #8, 7
	if Global.current_scene == "World":
		var target_tile: Vector2i = Vector2i(
			21,
			17
		) 
		global_position = tile_map.map_to_local(target_tile)
		sprite.global_position = tile_map.map_to_local(target_tile)
	elif Global.current_scene == "stage1":
		var target_tile: Vector2i = Vector2i(
			8,
			7
		) 
		global_position = tile_map.map_to_local(target_tile)
		sprite.global_position = tile_map.map_to_local(target_tile)
	var anim = $AnimatedSprite2D
	anim.play("default")


	

	
