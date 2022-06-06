extends Node

var player1

const QUAD_SIZE := 2
const CHUNK_QUAD_COUNT := 50
const CHUNK_SIZE = QUAD_SIZE * CHUNK_QUAD_COUNT

func _ready():
	player1 = get_tree().get_root().find_node("Player1, true, false")
