class KVPair
  attr_reader :key
  attr_accessor :value
  def initialize(key, value)
    @key, @value = key, value
  end
end

class Node
  attr_accessor :next, :prev, :val
  def initialize(val)
    @val = val
    @prev = nil
    @next = nil
  end
end

class DoublyLinkedList
  attr_reader :len
  def initialize
    @root = Node.new(nil)
    @len = 0

    root.next = root
    root.prev = root
  end

  def append(val)
    node = Node.new(val)

    node.next, node.prev = root, root.prev
    root.prev.next, root.prev = node, node

    inc_len
    node
  end

  def unshift(val)
    move_front(Node.new(val)) if inc_len
  end

  def move_front(node)
    return nil if node.nil?
    isolate(node) unless node.prev.nil? && node.next.nil?

    node.prev, node.next = root, root.next
    root.next.prev, root.next = node, node

    node
  end

  def remove_tail
    return nil if len.zero?
    isolate(root.prev) if dec_len
  end

  def isolate(node)
    node.prev.next = node.next
    node.next.prev = node.prev
    node.next, node.prev = nil, nil

    node
  end

  private
  attr_reader :root

  def inc_len; @len += 1; end
  def dec_len; @len -= 1; end
end

class LRUCache
  def initialize(max_size)
    raise 'Max size must be larger than zero' if max_size <= 0
    @max_size = max_size
    @list = DoublyLinkedList.new
    @nodes = Hash.new
  end

  def get(key)
    nodes[key].val.value if list.move_front(nodes[key])
  end

  def set(key, value)
    node = nodes[key]
    if !node.nil?
      node.val.value = value
      return
    end

    if list.len == max_size
      expired_node = list.remove_tail
      nodes.delete(expired_node.val.key)
    end

    nodes[key] = list.unshift(KVPair.new(key, value))
    nil
  end

  private
  attr_reader :list, :nodes, :max_size
end
