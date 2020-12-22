package lrucache

var (
	// ErrInvalidIndex occurs when the specified index is out of range
	ErrInvalidIndex = "invalid positional index"
)

// DoublyLinkedList is the DoublyLinkedList data structure
type DoublyLinkedList struct {
	len  int
	root Node
}

// Node represents a node in the linked list
type Node struct {
	prev  *Node
	next  *Node
	Value interface{}
}

// New creates a new LinkedList
func NewList() *DoublyLinkedList {
	l := new(DoublyLinkedList)
	l.root.next = &l.root
	l.root.prev = &l.root
	l.len = 0

	return l
}

// Length returns the length of the Linked List
func (l *DoublyLinkedList) Length() int {
	return l.len
}

// Unshift puts a at the front of the LinkedList
func (l *DoublyLinkedList) Unshift(val interface{}) *Node {
	defer func() { l.len++ }()

	newNode := &Node{
		Value: val,
		next:  l.root.next,
		prev:  &l.root,
	}

	l.root.next = newNode
	newNode.next.prev = newNode

	return newNode
}

// RemoveTail is going to remove the tail Node from the LinkedList
func (l *DoublyLinkedList) RemoveTail() *Node {
	return l.Remove(l.root.prev)
}

// Remove is going to remove the a Node from the LinkedList
func (l *DoublyLinkedList) Remove(node *Node) *Node {
	defer func() {
		l.len--
	}()

	tail := l.root.prev
	l.isolate(tail)
	return tail
}

func (l *DoublyLinkedList) isolate(node *Node) {
	node.next.prev = node.prev
	node.prev.next = node.next
	node.next, node.prev = nil, nil
}

// Movefront is going to move the passed in Node to the front of the Linked List
func (l *DoublyLinkedList) MoveFront(node *Node) {
	currentFront := l.root.next

	node.prev = &l.root
	l.root.next = node

	currentFront.prev = node
	node.next = currentFront
}

// Head returns the head of the LinkedList
func (l *DoublyLinkedList) Head() *Node {
	return l.root.next
}

// Tail returns the head of the LinkedList
func (l *DoublyLinkedList) Tail() *Node {
	return l.root.prev
}
