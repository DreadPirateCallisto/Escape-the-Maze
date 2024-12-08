extends Area2D

var textures = {
	'coin': 'res://assets/coin.png',
	'key_red': 'res://assets/keyRed.png',
	'star': 'res://assets/star.png'
}
var type
@onready var tween

func _ready():
	tween = create_tween()
	
func init(_type, pos):
	$Sprite2D.texture = load(textures[_type])
	type = _type
	pos
	
func pickup(item):
	$CollisionShape2D.disabled = true
	if item and not item.is_queued_for_deletion():
		tween.tween_property(
		$Sprite2D,
		'scale',
		Vector2(3, 3),
		0.5
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(
			$Sprite2D,
			'modulate',
			Color(1, 1, 1, 0),
			0.5
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		#await tween.finished
		tween.tween_callback(Callable(item, "queue_free"))
