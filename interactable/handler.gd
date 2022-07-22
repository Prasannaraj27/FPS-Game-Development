extends Node

signal interaction(node);

onready var main = get_tree().root.get_node("main");
var player: Spatial = null;

var nodes := Dictionary();
var action := "ui_accept";
var distance := 50.0;

func init(p: Spatial) -> void:
	player = p;

func _process(_delta) -> void:
	if Input.is_action_just_pressed(action):
		var min_distance := 100.0;
		var min_node: Spatial = null;
		for node in nodes.values():
			var distance: float = player.global_transform.origin.distance_to(node.global_transform.origin);
			if node.in_view and (distance <= min_distance):
				min_distance = distance;
				min_node = node;
		
		if min_node != null:
			emit_signal("interaction", min_node);

func create_object(handle, global_origin: Vector3, args: Array) -> void:
	var i = handle.instance();
	i.connect("destructor", self, "dereference_node");
	main.add_child(i);
	i.callv("init", args);
	i.global_transform.origin = global_origin;
	nodes[i.name] = i;

func dereference_node(n: Node) -> void:
	nodes.erase(n.name);
