extends Spatial

var threads : Array

var chunks := {}
var next_chunks := {}

var noise : OpenSimplexNoise
export var material: Material

onready var player1 = Globals.player1
var player_chunk_grid_location : Vector2



func _ready():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 20.0
	noise.persistence = 0.2
	
	var chunk = Chunk.new(Vector2(0,0), noise, material)
	chunk.generate()
	add_child(chunk)
