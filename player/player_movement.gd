extends KinematicBody

### export all the variables for debugging
export var velocity: Vector3 = Vector3.ZERO;
export var speed: float = 10.0;

export var pitch: float = 0.0;
export var yaw: float = 0.0;
export var delta_pitch: float = 0.0;
export var delta_yaw: float = 0.0;
export var pitch_speed: float = 0.2;
export var yaw_speed: float = 0.2;

export onready var gravity: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector") * ProjectSettings.get_setting("physics/3d/default_gravity");
export var floor_drag: float = 0.6;
export var air_drag: float = 0.9;
export var jump_force: float = 20.0;

export var forward: Vector3 = Vector3();
export var right: Vector3 = Vector3();
export var up: Vector3 = Vector3();

const Item = preload("res://inventory/item.gd");
const Bullet = preload("res://prefabs/BulletTest.tscn");

onready var camera = $camera;
onready var handler: Node = get_tree().root.get_node("main/handler");
onready var inventory = $inventory;
onready var main = get_tree().root.get_node("main");

func interact(object) -> void:
	if object is ItemObject:
		var overflow = inventory.add_items(object.item, object.item_amount);
		if overflow > 0:
			object.item_amount = overflow;
		else:
			object.queue_free();

func _ready() -> void:
	### set camera to follow player
	camera.target = self;
	
	### register interaction signal
	handler.connect("interaction", self, "interact")

### only way to capture mouse events
func _input(event) -> void:
	if event is InputEventMouseMotion:
		delta_pitch -= event.relative.y * pitch_speed;
		delta_yaw -= event.relative.x * yaw_speed;

func _process(delta) -> void:
	### just for testing purposes
	if Input.is_action_just_pressed("ui_cancel"):
		inventory.visible = not inventory.visible;

	if Input.is_mouse_button_pressed(1):
		var newBullet = Bullet.instance();
		print(camera.project_ray_origin(get_viewport().size / 2));
		print(camera.project_ray_normal(get_viewport().size / 2));
		newBullet.global_transform.origin = global_transform.origin;
		newBullet.get_node("RayCast").direction = -camera.global_transform.basis.z;
		main.add_child(newBullet);

func _physics_process(delta) -> void:
	var basis = transform.basis;
	forward = -basis.z;
	right = basis.x;
	up = basis.y;

	var on_ground: bool = is_on_floor();

	velocity += gravity * delta;
	var vertical_velocity: float = velocity.y;
	var horizontal_velocity: Vector3 = Vector3(velocity.x, 0.0, velocity.z);
	### -x, +x, -z, +z
	var input: Vector2 = Input.get_vector("left", "right", "forward", "backward");
	var horizontal_input: Vector3 = Vector3(input.x, 0.0, input.y);
	var horizontal_move: Vector3 = basis * horizontal_input;
	
	### apply movement speed
	horizontal_velocity = (horizontal_velocity + horizontal_move * speed) * floor_drag;

	### check for jumping
	if Input.is_action_pressed("jump") and on_ground:
		vertical_velocity += jump_force;

	if not on_ground and vertical_velocity > 0.0:
		vertical_velocity *= air_drag;

	velocity = horizontal_velocity + up * vertical_velocity;
	velocity = move_and_slide(velocity, up.normalized());

	var old_pitch = pitch;
	var old_yaw = yaw;

	### clamp pitch to straight up and straight down
	pitch = clamp(pitch + delta_pitch, -90, 90);
	### modulo yaw so it does inc/dec into inf/-inf
	yaw = fmod(yaw + delta_yaw, 360.0);
	
	### calculate relative rotation
	var rel_pitch = deg2rad(pitch - old_pitch);
	var rel_yaw = deg2rad(yaw - old_yaw);

	delta_pitch = 0.0;
	delta_yaw = 0.0;
	
	### the player itself should not pitch
	### pitch is instead only applied to the camera
	var a: Quat = Quat(camera.global_transform.basis);
	var b: Quat = Quat(camera.global_transform.rotated(right.normalized(), rel_pitch).basis);
	var c: Quat = a.slerp(b, 0.5);
	camera.global_transform.basis = Basis(c);

	### yaw player and camera
	global_rotate(up.normalized(), rel_yaw);
