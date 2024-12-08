extends Area2D

var tile_size: int = 64
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}
var facing = 'down'
var animation_speed = 3
var moving = false

@onready var ray = $RayCast2D
@onready var tween

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size/2
	
			
func move(dir):
	$AnimationPlayer.speed_scale = animation_speed
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += inputs[dir] * tile_size
		$AnimationPlayer.play(dir)
		tween = create_tween()
		tween.tween_property(self, "position",
		position+inputs[dir]*tile_size,
		1.0/animation_speed
		).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
	return true
