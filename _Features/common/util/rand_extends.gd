class_name RandExtends


static func randf_vector2(rangev: Vector2) -> float:
	return randf_range(rangev.x, rangev.y)


static func randi_vector2(rangev: Vector2i) -> int:
	return randi_range(rangev.x, rangev.y)


static func randv_range(from: Vector2, to: Vector2) -> Vector2:
	return Vector2(randf_range(from.x, to.x), randf_range(from.y, to.y))


static func rand_array(array: Array):
	if array.size() == 0:
		return null

	var index := randi_range(0, array.size() - 1)
	return array[index]
