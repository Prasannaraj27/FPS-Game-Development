extends RigidBody

### export all the variables for debugging
export var velocity: Vector3 = Vector3.ZERO;
export var speed: float = 10.0;
export var pitch: float = 0.0;
export var yaw: float = 0.0;
export var pitch_speed: float = 1.0;
export var rel_yaw: float = 0.0;
export var rel_pitch: float = 0.0;
export var yaw_speed: float = 1.0;
export var gravity: float = 9.8;
export var ground_drag: float = 0.5;
### apparently the z axis is supposed to be forward, not the x axis
export var forward: Vector3 = Vector3(1, 0, 0);
export var right: Vector3 = Vector3(0, 0, 1);
export var up: Vector3 = Vector3(0, 1, 0);

### array to hold mouse events
var mouse_events: Array = [];

func _ready():
	$camera.target = self;

### only way to capture mouse events
func _input(event):
	if event is InputEventMouseMotion:
		mouse_events.append(event);

func _physics_process(delta):
	### amount of movement this tick
	var move: Vector3 = Vector3.ZERO;
	var basis = get_transform().basis;
	### forward vector
	forward = basis.x;
	### right vector
	right = basis.z
	### up vector
	up = basis.y;
	
	### check for inputs
	if   Input.is_action_pressed("forward"):
		move += forward;
	elif Input.is_action_pressed("backward"):
		move -= forward;
	elif Input.is_action_pressed("right"):
		move += right;
	elif Input.is_action_pressed("left"):
		move -= right;
	
	### apply movement
	move *= speed;
	velocity += move;
	velocity -= up * gravity;
	add_central_force(velocity);
	velocity *= ground_drag;
	
	### delta_pitch and delta_yaw hold the relative change
	### of the mouse position since the last tick
	var delta_pitch = 0.0;
	var delta_yaw = 0.0;
	### save the old rotation values to calculate
	### relative rotation later
	var old_pitch = pitch;
	
	### sum up change since last tick
	for event in mouse_events:
		delta_pitch -= event.relative.y;
		delta_yaw -= event.relative.x;
	
	### reset the mouse_events vec
	mouse_events.clear();
	
	### clamp pitch to straight up and straight down
	pitch = clamp(pitch + delta_pitch * pitch_speed, -90, 90);
	### modulo yaw so it does inc/dec into inf/-inf
	yaw = fmod(yaw + delta_yaw * pitch_speed, 360.0);
	
	### calculate relative rotation
	rel_pitch = radians(pitch - old_pitch);
	
	### the player itself should not pitch
	### pitch is instead only applied to the camera
	$camera.global_rotate(right.normalized(), rel_pitch);

func _integrate_forces(state):
	### both the camera and player should yaw
	rotate_object_local(up.normalized(), radians(yaw));

### unfortunately no builtin radians function
func radians(n: float):
	return n * 3.1415 / 180.0;
