extends CharacterBody2D

@export var dialogue_json: JSON
@export var stage1_json: JSON
@onready var state = {}

@onready var tile_map = $"../TileMap"
@onready var sprite = get_node("AnimatedSprite2D")
@onready var npc = $"../ChickenNPC"


var current_dir = "none"
var is_moving = false
var event = false
var hole = false

signal falling
signal finish_falling

func _physics_process(delta):
	if not event:
		player_Movement(delta)
	
	if not is_moving:
		return
	
	if global_position == sprite.global_position:
		is_moving = false
		if hole:
			Global.falling = true
			falling.emit()
			
			event = true
			for i in range(1, 200):
				velocity.y += 5
				rotate(0.1)
				move_and_slide()
				await get_tree().create_timer(0.01).timeout
			event = false
			Global.falling = false
			finish_falling.emit()
			if Global.current_scene == "stage1":
				var newtarget_tile: Vector2i = Vector2i(
				18,
				17
				) 
				global_position = tile_map.map_to_local(newtarget_tile)
				sprite.global_position = tile_map.map_to_local(newtarget_tile)
				rotation = 0
				velocity.y = 0
		return
		
	var speed = 0.7
	
	if Input.is_action_pressed("Shift"):
		speed = 1.2
	
	sprite.global_position = sprite.global_position.move_toward(global_position, speed)
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	if Global.current_scene == "World":
		if (current_tile.x == 42 or current_tile.x == 43) and current_tile.y == 16:
			Global.current_scene = "stage1"
			get_tree().change_scene_to_file("res://stage1.tscn")
			
	
func _ready():
	current_dir = "down"
	play_anim(0)
	if Global.current_scene == "World":
		var target_tile: Vector2i = Vector2i(
			18,
			17
		) 
		global_position = tile_map.map_to_local(target_tile)
		sprite.global_position = tile_map.map_to_local(target_tile)
	elif Global.current_scene == "stage1":
		var target_tile: Vector2i = Vector2i(
			18,
			17
		) 
		global_position = tile_map.map_to_local(target_tile)
		sprite.global_position = tile_map.map_to_local(target_tile)
	

func player_Movement(_delta):
	if is_moving:
		return
	
	if Input.is_action_pressed("ui_right"):
		move(Vector2.RIGHT)

		current_dir = "right"
		play_anim(1)
	elif Input.is_action_pressed("ui_left"):
		move(Vector2.LEFT)

		current_dir = "left"
		play_anim(1)
	elif Input.is_action_pressed("ui_up"):
		move(Vector2.UP)

		current_dir = "up"
		play_anim(1)
	elif Input.is_action_pressed("ui_down"):
		move(Vector2.DOWN)

		current_dir = "down"
		play_anim(1)
	else:
		play_anim(0)
	#move_and_slide()
	
func move(direction: Vector2):
	
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	) 
	var tile_data : TileData = tile_map.get_cell_tile_data(0, target_tile)
	var tile_dataAbove : TileData = tile_map.get_cell_tile_data(1, target_tile)
	
	if tile_data == null:
		return
		
	if tile_data.get_custom_data("Walkable") == false:
		return
		
	if not tile_dataAbove == null:
		if tile_dataAbove.get_custom_data("Walkable") == false:
			return
			
	if tile_data.get_custom_data("Hole") == true:
		hole = true
	else: 
		hole = false

	
	var location = tile_map.map_to_local(target_tile)
	if location == npc.global_position:
		return
	
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	sprite.global_position = tile_map.map_to_local(current_tile)
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		if movement == 1:
			anim.play("right")
		else:
			anim.play("right_idle") 
	elif dir == "down":
		if movement == 1:
			anim.play("down")
		else:
			anim.play("down_idle") 
	elif dir == "left":
		if movement == 1:
			anim.play("left")
		else:
			anim.play("left_idle") 
	elif dir == "up":
		if movement == 1:
			anim.play("up")
		else:
			anim.play("up_idle") 

func end_of_interaction():
	event = false

func interaction():
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		check_interactable(Vector2.RIGHT)
	elif dir == "down":
		check_interactable(Vector2.DOWN)
	elif dir == "left":
		check_interactable(Vector2.LEFT)
	elif dir == "up":
		check_interactable(Vector2.UP)
		
func check_interactable(direction: Vector2):
	
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	) 
	
	
	#var tile_data : TileData = tile_map.get_cell_tile_data(0, target_tile)
	#var tile_dataAbove : TileData = tile_map.get_cell_tile_data(1, target_tile)
	#
	#if tile_data == null:
		#return
		#
	#if tile_data.get_custom_data("Walkable") == false:
		#return
		#
	#if not tile_dataAbove == null:
		#if tile_dataAbove.get_custom_data("Walkable") == false:
			#return
	#
	#var location = tile_map.map_to_local(target_tile)
	#if location == npc.global_position:
		#return	
