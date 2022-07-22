extends RigidBody

var navAgent : NavigationAgent;
export(NodePath) var targetNode;
#export(NodePath) var targetNode2;
#export(NodePath) var targetNode3;
onready var targetNodeObject : Spatial = get_node(targetNode);
#onready var targetNodeObject2 : Spatial = get_node(targetNode2);
#onready var targetNodeObject3 : Spatial = get_node(targetNode3);
#export(NodePath) var timerNode;
#onready var timer : Timer = get_node(timerNode);

# Called when the node enters the scene tree for the first time.
func _ready():
	navAgent = $NavigationAgent;
	navAgent.set_target_location(targetNodeObject.global_transform.origin);
	#timer.start(2);

func _physics_process(delta):
	var currentPos = global_transform.origin;
	var target = navAgent.get_next_location();
	var velocity = Vector3();
	var normal = $RayCast.get_collision_normal();
	var absNormal = Vector3(abs(normal.x), abs(normal.y), abs(normal.z));
	var invFloorNormal = Vector3(1, 1, 1) - absNormal;
	
	velocity = ((target - currentPos) * invFloorNormal).normalized() * 10;
	#velocity = (target - currentPos).normalized() * 10;
	navAgent.set_velocity(velocity);

func _on_NavigationAgent_velocity_computed(safe_velocity):
	set_linear_velocity(safe_velocity);

#func _change_target(currentTarget):
	#print(targetNodeObject.global_transform.origin)
	#print(targetNodeObject2.global_transform.origin)
	#if currentTarget == targetNodeObject.global_transform.origin:
	#	navAgent.set_target_location(targetNodeObject2.global_transform.origin);
	#elif currentTarget == targetNodeObject2.global_transform.origin:
	#	navAgent.set_target_location(targetNodeObject3.global_transform.origin);
	#else:
	#	navAgent.set_target_location(targetNodeObject.global_transform.origin);

#func _on_LocTimer_timeout():
	#print("yes");
	#print(navAgent.get_target_location());
	#print(navAgent.get_next_location());
	#navAgent.set_target_location(targetNodeObject.global_transform.origin);
	#_change_target(targetNodeObject2.global_transform.origin);
	
