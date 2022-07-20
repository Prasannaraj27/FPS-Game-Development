class_name Inventory

var items: Dictionary = Dictionary();

func add(i: Item):
	if items.has(i):
		items[i] += 1;
	else:
		items[i] = 1;
