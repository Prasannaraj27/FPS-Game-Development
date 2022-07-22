extends RayCast

export var destroyAfter = 1;
export var direction := Basis();
export var move := Vector3();
export var speed = 10.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	self.move = direction * Vector3.FORWARD * speed;
	look_at(global_transform.origin + self.move, Vector3.UP);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform.origin += self.move * delta;
	destroyAfter -= delta;
	if destroyAfter <= 0.0:
		queue_free();
	if is_colliding():
		print("colliding")
		if get_collider().is_in_group("enemy"):
			#get_collider().takeDamage();
			print("why");
			pass
		else:
			print("yes");
			queue_free();
