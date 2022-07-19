class_name Queue

var head = null;
var tail = null;
var length = 0;

func push_back(v):
	var e = QueueEntry.new(v);
	
	if tail != null:
		tail.bk = e;
		e.fd = tail;
	else:
		if head != null:
			head.bk = e;
		else:
			head = e;
	
	length += 1;
	tail = e;

func pop_back():
	var e = tail;
	if tail != null:
		tail = tail.fd;
		
	return e.inner;
	
func push_front(v):
	var e = QueueEntry.new(v);

	if head != null:
		head.fd = e;
		e.bk = head;
	else:
		if tail != null:
			tail.fd = e;
		else:
			tail = e;

	length += 1;
	head = e;

func pop_front():
	var e = head;
	if head != null:
		head = head.bk;
		
	return e.inner;

func len():
	return length;
	
func empty():
	head = null;
	tail = null;
	length = 0;

func consume():
	var entries: Array = [];
	var h = head;
	
	while h != null:
		entries.append(h.inner);
		h = h.bk;
		
	empty();
		
	return entries;
