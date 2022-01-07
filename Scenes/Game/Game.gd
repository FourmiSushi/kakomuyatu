extends Node2D

var SquareLarge = preload("res://Scenes/Square/SquareLarge.tscn") # 生成用に読み込んでおく
var SquareMedium = preload("res://Scenes/Square/SquareMedium.tscn")
var SquareSmall = preload("res://Scenes/Square/SquareSmall.tscn")

var result = load("res://Scenes/Result/Result.tscn")

var screen_size = Vector2()

func _ready():
	screen_size = get_viewport_rect().size
	$SpawnTimer.start()
	$GameTimer.start()
	
func _process(delta: float) -> void:
	$UI/Score.text = "Score: %d" % ScoreManager.score
	$UI/Time.text = "Time: %.2f" % $GameTimer.time_left

func _on_SpawnTimer_timeout():
	# 2秒ごとに新しいSquareを生成
	var newSquare = SquareLarge.instance()
	newSquare.position = Vector2(screen_size.x / 2, screen_size.y)
	newSquare.add_torque(128)
	newSquare.apply_central_impulse(Vector2(0, -640))
	add_child(newSquare)

func _on_square_fell(body):
	# 下に落ちたら再生成
	var newSquare
	match body.square_size:
		"Large":
			newSquare = SquareLarge.instance()
		"Medium":
			newSquare = SquareMedium.instance()
		"Small":
			newSquare = SquareSmall.instance()
	newSquare.position = Vector2(body.position.x, screen_size.y)
	newSquare.angular_velocity = body.angular_velocity
	newSquare.apply_central_impulse(Vector2(body.linear_velocity.x, -640))
	add_child(newSquare)


func _on_GameTimer_timeout() -> void:
	get_tree().change_scene_to(result)
