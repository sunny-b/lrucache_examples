class KVPair {
  constructor(key, value) {
    this.key = key
    this.value = value
  }
}

class Node {
  constructor(data) {
    this.data = data
    this.next = null
    this.prev = null
  }
}

class DoublyLinkedList {
  constructor() {
    this.root = new Node(null)
    this.len = 0

    this.root.next = this.root
    this.root.prev = this.root
  }

  moveFront(node) {
    if (node === undefined || node === null) {
      return null
    } else if (node.prev !== null && node.next !== null) {
      this.isolate(node)
    }
    const oldHead = this.root.next

    node.prev = this.root
    node.next = oldHead
    oldHead.prev = node
    this.root.next = node

    return node
  }

  unshift(data) {
		const node = new Node(data)
    this.moveFront(node)
    this.incLen()
		return node
  }

  isolate(node) {
    node.prev.next = node.next
    node.next.prev = node.prev
    node.next = null
    node.prev = null
    return node
  }

  remove(node) {
    if (this.len === 0) { return null }
    this.decLen()

    return this.isolate(node)
  }

  removeTail() {
    return this.remove(this.root.prev)
  }

  incLen() { this.len++ }
  decLen() { this.len-- }
}

class LRUCache {
  constructor(maxSize) {
    if (maxSize <= 0) { throw new Error('Max size must be larger than zero') }
    this.maxSize = maxSize
    this.list = new DoublyLinkedList()
    this.nodes = {}
  }

  get(key) {
    const node = this.nodes[key]
    if (node === undefined) {
      return null
    }

    this.list.moveFront(node)
    return node.data.value
  }

  set(key, value) {
    const node = this.nodes[key]
    if (node !== undefined) {
			node.data.value = value
			this.list.moveFront(node)
      return
    }

    if (this.list.len === this.maxSize) {
      const expiredNode = this.list.removeTail()
      delete this.nodes[expiredNode.data.key]
    }

    this.nodes[key] = this.list.unshift(new KVPair(key, value))
  }

  invalidate(key) {
    if (this.nodes[key] === undefined) { return null }

    const node = this.list.remove(this.nodes[key])
    delete this.nodes[key]

    return node.data.value
  }
}

module.exports = LRUCache
