extends Spatial

var threads : Array

var chunks := {}
var next_chunks := {}

var noise : OpenSimplexNoise
export var material: Material

onready var player = Globals.player
var player_chunk_grid_position : Vector2



func _ready() -> void:
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 1
	noise.period = 20.0
	noise.persistence = 0.7
	
	player_chunk_grid_position = get_chunk_grid_position_for(player.translation)
	
	generate_chunk([Chunk.new(player_chunk_grid_position, noise, material), null])
	generate_chunks_around(player_chunk_grid_position)
	call_deferred("clean_old_chunks", player_chunk_grid_position)

func _process(delta):
	var old_player_chunk_grid_position = player_chunk_grid_position
	player_chunk_grid_position = get_chunk_grid_position_for(player.translation)
	if old_player_chunk_grid_position != player_chunk_grid_position:
		generate_chunks_around(player_chunk_grid_position)

func generate_chunks_around(grid_position):
	start_generating_chunk(Vector2(grid_position.x + 1, grid_position.y + 0))
	start_generating_chunk(Vector2(grid_position.x + 1, grid_position.y + 1))
	start_generating_chunk(Vector2(grid_position.x + 1, grid_position.y + -1))
	start_generating_chunk(Vector2(grid_position.x + 0, grid_position.y + 1))
	start_generating_chunk(Vector2(grid_position.x + -1, grid_position.y + 0))
	start_generating_chunk(Vector2(grid_position.x + -1, grid_position.y + -1))
	start_generating_chunk(Vector2(grid_position.x + -1, grid_position.y + 1))
	start_generating_chunk(Vector2(grid_position.x + 0, grid_position.y + -1))

func start_generating_chunk(grind_position: Vector2):
	var chunk = Chunk.new(grind_position, noise, material)
	if not chunks.has(chunk.key) and not next_chunks.has(chunk.key):
		var thread = Thread.new()
		next_chunks[chunk.key] = chunk
		print("Generating " + chunk.key)
		thread.start(self, "generate_chunk", [chunk, thread])
		threads.push_back(thread)

func generate_chunk(arr):
	var chunk = arr[0]
	var thread = arr[1]
	
	chunk.generate()
	call_deferred("finished_generating_chunk", thread, chunk)

func finished_generating_chunk(thread, chunk):
	chunks[chunk.key] = chunk
	next_chunks.erase(chunk.key)
	
	chunk.create_collider()
	call_deferred("add_child", chunk)
	chunk.call_deferred("set_owner", self)
	
	if not thread:
		 return
		
	thread.wait_to_finish()
	var index = threads.find(thread)
	if index != -1:
		threads.remove(index)

func cleanup_old_chunks(center_grid_position : Vector2):
	var valid_chunks = [
		"TerrainChunk_%d_%d" % [center_grid_position.x - 1, center_grid_position.y - 1],
		"TerrainChunk_%d_%d" % [center_grid_position.x, center_grid_position.y - 1],
		"TerrainChunk_%d_%d" % [center_grid_position.x + 1, center_grid_position.y - 1],
		"TerrainChunk_%d_%d" % [center_grid_position.x - 1, center_grid_position.y],
		"TerrainChunk_%d_%d" % [center_grid_position.x, center_grid_position.y],
		"TerrainChunk_%d_%d" % [center_grid_position.x + 1, center_grid_position.y],
		"TerrainChunk_%d_%d" % [center_grid_position.x - 1, center_grid_position.y + 1],
		"TerrainChunk_%d_%d" % [center_grid_position.x, center_grid_position.y + 1],
		"TerrainChunk_%d_%d" % [center_grid_position.x + 1, center_grid_position.y + 1]
	]
	var keys_to_erase = []
	for key in chunks.keys():
		if not valid_chunks.has(key):
			keys_to_erase.push_back(key)

func get_chunk_grid_position_for(position):
	var start = Vector2(position.x, position.z)
	if start.x > 0:
		start.x += Globals.CHUNK_SIZE / 2.0
	elif start.x < 0:
		start.x -= Globals.CHUNK_SIZE / 2.0
	if start.y > 0:
		start.y += Globals.CHUNK_SIZE / 2.0
	elif start.y < 0:
		start.y -= Globals.CHUNK_SIZE / 2.0
		
	return Vector2(
		int(start.x / Globals.CHUNK_SIZE),
		int(start.y / Globals.CHUNK_SIZE)
	)
