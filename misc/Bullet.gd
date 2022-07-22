extends RayCast

export var destroyAfter = 1;
export var direction := Vector3();
export var speed = 10.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin += direction * speed * delta;
	destroyAfter -= delta;
	if destroyAfter <= 0.0:
		queue_free();
