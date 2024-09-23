extends Camera2D

const SCREEN_SIZE = Vector2(600, 300)
@onready var player: CharacterBody2D = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	camera_panning()


func camera_panning():
	position = player.global_position
	var x = floor(position.x / SCREEN_SIZE.x) * SCREEN_SIZE.x
	var y = floor(position.y / SCREEN_SIZE.y) * SCREEN_SIZE.y
	position = Vector2(x,y)
