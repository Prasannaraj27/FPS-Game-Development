class_name Queue

var head = null;
var tail = null;
var length = 0;

func push_back(v):
	var e = QueueEntry.new(v);
	
	if self.tail != null:
		self.tail.bk = e;
		e.fd = self.tail;
	else:
		if self.head != null:
			self.head.bk = e;
		else:
			self.head = e;
	
	length += 1;
	self.tail = e;

func pop_back():
	var e = self.tail;
	if self.tail != null:
		self.tail = self.tail.fd;
		
	return e.inner;
	
func push_front(v):
	var e = QueueEntry.new(v);

	if self.head != null:
		self.head.fd = e;
		e.bk = self.head;
	else:
		if self.tail != null:
			self.tail.fd = e;
		else:
			self.tail = e;

	length += 1;
	self.head = e;

func pop_front():
	var e = self.head;
	if self.head != null:
		self.head = self.head.bk;
		
	return e.inner;

func len():
	return self.length;
	
func empty():
	self.head = null;
	self.tail = null;
	self.length = 0;

func consume():
	var entries: Array = [];
	var h = self.head;
	
	while h != null:
		entries.append(h.inner);
		h = h.bk;
		
	self.empty();
		
	return entries;
