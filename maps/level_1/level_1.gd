extends Node2D

@export var Enemy: PackedScene
@export var Pickup: PackedScene

@onready var items = $Items
var doors = []

func _ready():
	randomize()
	$Items.hide()
	set_camera_limits()
	var door_id = $Walls.tile_set.get_custom_data_layer_by_name('Doors')
	for cell in $Walls.get_used_cells_by_id(door_id):
		doors.append(cell)
	spawn_items()
	#$Player.connect('dead', self, 'game_over')
	$Player.dead.connect(game_over)
	#$Player.connect('grabbed_key', self, '_on_Player_grabbed_key')
	$Player.grabbed_key.connect(_on_Player_grabbed_key)
	#$Player.connect('win', self, '_on_Player_win')
	$Player.win.connect(_on_Player_win)

func set_camera_limits():
	var map_size = $Ground.get_used_rect()
	var cell_size = $Ground.tile_set.tile_size
	$Player/Camera2D.limit_left = map_size.position.x * cell_size.x
	$Player/Camera2D.limit_top = map_size.position.y * cell_size.y
	$Player/Camera2D.limit_right = map_size.end.x * cell_size.x
	$Player/Camera2D.limit_bottom = map_size.end.y * cell_size.y
	
func spawn_items():
	#$Items.show()
	for cell in items.get_used_cells(0):
		var tile_data = items.get_cell_tile_data(0, cell)
		var type = tile_data.get_custom_data("type")
		var pos = items.map_to_local(cell) + items.map_to_local(items.tile_set.tile_size/2)
		
		match type:
			'enemy':
				var s = Enemy.instantiate()
				s.position = pos
				s.tile_size = items.tile_size
				add_child(s)
			'player_spawn':
				$Player.position = pos
				#$Player.tile_size = items.map_to_local(items.tile_set.tile_size).x
				print($Player.position)
				$Player.show()
			'coin', 'key_red', 'star':
				var p = Pickup.instantiate()
				p.init(type, pos)
				add_child(p)
		

func game_over():
	pass

func _on_Player_win():
	pass
	
func _on_Player_grabbed_key():
	for cell in doors:
		$Walls.set_cellv(cell, -1)
