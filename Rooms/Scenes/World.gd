extends Node2D

var basic_tile_size = 32
var ts = 32
var map_size = OS.window_size/ts
var offset = Vector2(16, 16)

var num_rooms = 15

var min_size = 4
var max_size = 10

var floors = []
var walls = []
var rooms = []

var closedPoints = []
var closedX = []
var closedY = []

class Floor:
	var pos = Vector2()
	var size = Vector2(32, 32)
	var sprite = Sprite.new()
	var color = Color("#4c402a")
	var zIndex = 1
	var groups = ["static", "floor"]
	func Init(pos):
		self.pos = pos

class Wall:
	var pos = Vector2()
	var size = Vector2(32, 32)
	var sprite = Sprite.new()
	var color = Color("#180b0b")
	var zIndex = 2
	var groups = ["static", "wall"]
	func Init(pos):
		self.pos = pos

class Room:
	var pos = Vector2()
	var size = Vector2()
	var groups = ["construction", "room"]
	func Init(pos, size):
		self.pos = pos
		self.size = size

func CreateSprite(obj, pos, size, color, zIndex, groups):
	var sprite = Sprite.new()
	var imageTexture = ImageTexture.new()
	var img = Image.new()
	img.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	img.lock()
	img.fill(color)
	img.unlock()
	imageTexture.create_from_image(img)
	sprite.texture = imageTexture
	sprite.position = pos
	sprite.z_index = zIndex
	for group in groups:
		sprite.add_to_group(group) #persistent=false
	global.current_scene.add_child(sprite)
	return sprite

func _ready():
	randomize()
	GenerateFloor()
	GenerateDangeon()
	
	#GenerateRoom(Vector2(32, 32)+offset, Vector2(8, 8))
	#yield(get_tree().create_timer(1), 'timeout')
	pass

func CreateFloor(pos):
	var tile = Floor.new()
	tile.Init(pos + offset)
	tile.sprite = CreateSprite(tile, tile.pos, tile.size, tile.color, tile.zIndex, tile.groups)
	floors.append(tile)

func CreateWall(pos, color = null):
	var tile = Wall.new()
	tile.Init(pos + offset)
	if color != null:
		tile.color = color
	tile.sprite = CreateSprite(tile, tile.pos, tile.size, tile.color, tile.zIndex, tile.groups)
	var text = str(more.GlobaToIndex(pos))
	CreateLabel(pos, text, tile.sprite)
	walls.append(tile)

func GenerateFloor():
	for y in map_size.y:
		for x in map_size.x:
			CreateFloor(Vector2(x*ts, y*ts))

func GenerateRoom(pos, size):
	var room = Room.new()
	var color = more.ColorRand()
	room.Init(pos, size)
	var mas = []
	for y in size.y:
		for x in size.x:
			var point = more.GlobalToPoint(pos)+Vector2(x, y)
			floors[more.PointToIndex(point)].sprite.modulate = Color(0, 0, 0, 1)
			closedPoints.append(point)
			if ((y == 0) || (x == 0) || (y == size.y-1) || (x == size.x-1)): 
				var _pos = pos + Vector2(x*ts, y*ts)
				CreateWall(_pos, color)
	rooms.append(room)
		

func CreateLabel(pos, text, node = null):
	var l = Label.new()
	l.rect_size = Vector2(ts, ts)
	l.rect_position -= offset#pos
	l.set_align(Label.ALIGN_CENTER)
	l.set_valign(Label.VALIGN_CENTER)
	l.set_text(text)
	node.add_child(l)

func GenerateDangeon():
	for i in 5:#num_rooms:
		var size = Vector2(more.IntRand(min_size, max_size), more.IntRand(min_size, max_size))
		var pos = RoomPosRandom(size)
		if pos == null:
			continue
		GenerateRoom(pos, size)
		pass

func RoomPosRandom(size):
	var new_space = []
	for y in size.y:
		for x in size.x:
			new_space.append(Vector2(x, y))
	var openPoints = []
	var flag = false
	for y in map_size.y:
		for x in map_size.x:
			var point = Vector2(x ,y)
			if closedPoints.has(point):
				continue
			for new_point in new_space:
				if closedPoints.has(point+new_point):
					flag = true
					break
			if !flag && point.x <= map_size.x - size.x && point.y <= map_size.y - size.y:
				openPoints.append(point)
			flag = false
	var idx = more.IntRand(0, openPoints.size()-1)
	if idx == null:
		return null
	var point = openPoints[idx]
	return more.PointToGlobal(point)




