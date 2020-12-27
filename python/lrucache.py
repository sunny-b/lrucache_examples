class KVPair(object):
    def __init__(self, k, v):
        self.key = k
        self.value = v

class Node(object):
    def __init__(self, data):
        self.data = data
        self.next = None
        self.prev = None

class DoublyLinkedList(object):
    def __init__(self):
        self.root = Node(None)
        self.len = 0

        self.root.next = self.root
        self.root.prev = self.root

    def unshift(self, data):
        node = Node(data)

        self.move_front(node)
        self.inc_len()
        return node

    def move_front(self, node):
        if node is None:
            return None
        elif node.prev is not None and node.next is not None:
            self.isolate(node)

        node.prev = self.root
        node.next = self.root.next
        self.root.next.prev = node
        self.root.next = node

        return node

    def remove_tail(self):
        return self.remove(self.root.prev)

    def remove(self, node):
        if self.len == 0:
            return None
        self.dec_len()
        return self.isolate(node)

    @staticmethod
    def isolate(node):
        node.next.prev = node.prev
        node.prev.next = node.next
        node.next = None
        node.prev = None
        return node

    def inc_len(self):
        self.len += 1
    def dec_len(self):
        self.len -= 1

class LRUCache(object):
    def __init__(self, max_size=10):
        if max_size <= 0:
            raise Exception('Max size must be larger than zero')
        self.max_size = max_size
        self.list = DoublyLinkedList()
        self.nodes = {}

    def set(self, key, value):
        node = self.nodes.get(key, None)
        if node != None:
            node.data.value = value
            self.list.move_front(node)
            return

        if self.list.len == self.max_size:
            expired = self.list.remove_tail()
            del self.nodes[expired.data.key]

        self.nodes[key] = self.list.unshift(KVPair(key, value))

    def get(self, key):
        node = self.nodes.get(key, None)
        if node is None:
            return None

        self.list.move_front(node)
        return node.data.value

    def invalidate(self, key):
        if self.nodes.get(key, None) is None:
            return None

        node = self.list.remove(self.nodes[key])
        del self.nodes[key]

        return node.data.value
