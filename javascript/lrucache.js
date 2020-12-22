class KVPair {
  constructor(key, value) {
    this.key = key
    this.value = value
  }
}

class Node {
  constructor(val) {
    this.val = val
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

  unshift(val) {
    this.moveFront(new Node(val))
    this.incLen()
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
    return node.val.value
  }

  set(key, value) {
    const node = this.nodes[key]
    if (node !== undefined) {
      node.val.value = value
      return
    }

    if (this.list.len === this.maxSize) {
      const expiredNode = this.list.removeTail()
      delete this.nodes[expiredNode.val.key]
    }

    this.nodes[key] = this.list.unshift(new KVPair(key, value))
  }

  invalidate(key) {
    if (this.nodes[key] === undefined) { return null }

    const node = this.list.remove(this.nodes[key])
    delete this.nodes[key]

    return node.val.value
  }
}
