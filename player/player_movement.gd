extends KinematicBody

### export all the variables for debugging
export var velocity: Vector3 = Vector3.ZERO;
export var speed: float = 10.0;

export var pitch: float = 0.0;
export var yaw: float = 0.0;
export var old_pitch: float = 0.0;
export var old_yaw: float = 0.0;
export var rel_pitch: float = 0.0;
export var rel_yaw: float = 0.0;
export var pitch_speed: float = 1.0;
export var yaw_speed: float = 1.0;

export onready var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector") * ProjectSettings.get_setting("physics/3d/default_gravity");
export var floor_drag: float = 0.6;
export var air_drag: float = 0.9;
export var jump_force: float = 5.0;

### apparently the z axis is supposed to be forward, not the x axis
export var forward: Vector3 = Vector3(1, 0, 0);
export var right: Vector3 = Vector3(0, 0, 1);
export var up: Vector3 = Vector3(0, 1, 0);

func _ready():
	### set camera to follow player
	$camera.target = self;

### only way to capture mouse events
func _input(event):
	if event is InputEventMouseMotion:
		pitch -= event.relative.y * pitch_speed;
		yaw -= event.relative.x * yaw_speed;

func _physics_process(delta):
	var basis = get_transform().basis;
	### forward vector
	forward = basis.x;
	### right vector
	right = basis.z
	### up vector
	up = basis.y;

	### velocity += gravity * delta;
	var velocity_vertical = velocity.y;
	var velocity_horizontal = Vector3(velocity.x, 0.0, velocity.y);
	var horizontal_move = Vector3.ZERO;
	
	### check for inputs
	if   Input.is_action_pressed("forward"):
		horizontal_move += forward;
	elif Input.is_action_pressed("backward"):
		horizontal_move -= forward;
	elif Input.is_action_pressed("right"):
		horizontal_move += right;
	elif Input.is_action_pressed("left"):
		horizontal_move -= right;
	
	### apply movement speed before jumping
	horizontal_move *= speed;
	velocity_horizontal = (velocity_horizontal + horizontal_move) * floor_drag;

	### check for jumping
	if Input.is_action_pressed("jump"):
		velocity_vertical += jump_force;

	velocity_vertical *= air_drag;

	velocity = velocity_horizontal + up * velocity_vertical;
	velocity = move_and_slide(velocity);
	
	### clamp pitch to straight up and straight down
	pitch = clamp(pitch, -90, 90);
	### modulo yaw so it does inc/dec into inf/-inf
	yaw = fmod(yaw, 360.0);
	
	### calculate relative rotation
	rel_pitch = radians(pitch - old_pitch);
	rel_yaw = radians(yaw - old_yaw);

	### save pitch
	old_pitch = pitch;
	old_yaw = yaw;
	
	### the player itself should not pitch
	### pitch is instead only applied to the camera
	var a: Quat = Quat($camera.global_transform.basis);
	var b: Quat = Quat($camera.global_transform.rotated(right.normalized(), rel_pitch).basis);
	var c: Quat = a.slerp(b, 0.5);
	$camera.global_transform.basis = Basis(c);

	a = Quat(transform.basis);
	b = Quat(transform.rotated(up.normalized(), rel_yaw).basis);
	c = a.slerp(b, 0.5);
	transform.basis = Basis(c);

### unfortunately no builtin radians function
func radians(n: float):
	return n * 3.1415 / 180.0;
