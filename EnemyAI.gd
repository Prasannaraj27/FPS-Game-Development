extends RigidBody

var navAgent : NavigationAgent;
export(NodePath) var targetNode;

# Called when the node enters the scene tree for the first time.
func _ready():
	navAgent = $NavigationAgent;
	var targetNodeObject : Spatial = get_node(targetNode);
	navAgent.set_target_location(targetNodeObject.global_transform.origin);

func _physics_process(delta):
	var currentPos = global_transform.origin;
	var target = navAgent.get_next_location();
	var velocity = Vector3();
	var normal = $RayCast.get_collision_normal();
	var absNormal = Vector3(abs(normal.x), abs(normal.y), abs(normal.z));
	var invFloorNormal = Vector3(1, 1, 1) - absNormal;
	velocity = ((target - currentPos) * invFloorNormal).normalized() * 10;
	navAgent.set_velocity(velocity);


func _on_NavigationAgent_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity);
