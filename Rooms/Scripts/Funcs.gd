extends Node

func _ready():
	randomize(true)

func IntRand(_min, _max):
	if _min > _max:
		return null
	return int(_min + randi() % (_max - _min + 1))

func RoundRand(a, b):
	return round(rand_range(a, b))

func BoolRand():
	var r = round(rand_range(0, 1))
	if r == 0:
		return false
	else:
		return true

func SelectiveRand(a, b):
	return a if bool_rand() else b

func ExcludingRand(a, b, c):
	var mas = []
	for i in range(a, b+1):
		if typeof(c) == TYPE_ARRAY and c.has(i):
			continue
		elif typeof(c) == TYPE_INT and c == i:
			continue
		else:
			mas.append(i)
	var rand = IntRand(0, mas.size()-1)
	if rand == null:
		return null
	return mas[rand]

func ColorRand(alpha = false):
	return (Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1) if !alpha
	 else Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), rand_range(0, 1)))

func GlobalToPoint(pos):
	return Vector2(pos.x, pos.y)/global.ts

func PointToGlobal(point):
	return Vector2(point.x, point.y)*global.ts

func GlobaToIndex(pos):
	var point = GlobalToPoint(pos)
	return (point.y*global.map_size.x + point.x)

func PointToIndex(point):
	return (point.y*global.map_size.x + point.x)

func IndexToPoint(index):
	var x = int(index)%int(global.map_size.x)
	var y = floor(index/global.map_size.x)
	return Vector2(x, y)

func IndexToGlobal(index):
	return PointToGlobal(IndexToPoint(index))

func VectorsComparison(v1, v2, operation):
	if operation == ">=":
		if v1.x >= v2.x && v1.y >= v2.y:
			pass


