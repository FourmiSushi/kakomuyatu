extends RigidBody2D

signal square_fell(body) # 追加 引数つきsignal

# exportの変数はGUIエディタからいじることができる
export (PackedScene) var child_square # 一つ小さい四角形のシーン
export (String) var square_size

var explosion = preload("res://Scenes/Explosion/Explosion.tscn")

var child_spread = 128
var torque_range = 128
var screen_size = Vector2()

func _ready():
	randomize() # 乱数をランダムにするやつ
	screen_size = get_viewport_rect().size # 画面サイズを取得
	connect("square_fell", get_parent(), "_on_square_fell")

func _on_captured():
	var parent = get_parent() # 親ノード
	
	if parent.name == "Game":
		ScoreManager.score += 1
		
	if child_square != null:
		for i in range(4):
			var child = child_square.instance() # シーンからノードを作成
			child.position = position
			child.add_torque(rand_range(-1 * torque_range, torque_range)) # 回転を加える
			var force = Vector2(rand_range(-1 * child_spread, child_spread) , rand_range(-1 * child_spread, 0)) # ある程度ランダムな方向に飛ばす
			child.apply_central_impulse(force) # 撃力
			parent.add_child(child)
	var e = explosion.instance()
	e.position = position
	e.emitting = true
	parent.add_child(e)
	queue_free() # 自身を消去
	
func _physics_process(delta):
	# 画面外に行ったときの処理
	if position.y > screen_size.y:
		emit_signal("square_fell", self) # 追加
		queue_free()
	if position.x < 0 or position.x > screen_size.x:
		queue_free()
