class KVPair
  attr_reader :key
  attr_accessor :value
  def initialize(key, value)
    @key, @value = key, value
  end
end

class Node
  attr_accessor :next, :prev, :data
  def initialize(data)
    @data = data
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

  def unshift(data)
    move_front(Node.new(data)) if inc_len
  end

  def move_front(node)
    return nil if node.nil?
    isolate(node) unless node.prev.nil? && node.next.nil?

    node.prev, node.next = root, root.next
    root.next.prev, root.next = node, node

    node
  end

  def remove_tail
    remove(root.prev)
  end

  def remove(node)
    return nil if len.zero?
    isolate(node) if dec_len
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
    nodes[key].data.value if list.move_front(nodes[key])
  end

  def set(key, value)
    node = nodes[key]
    if !node.nil?
      node.data.value = value
      list.move_front(node)
      return
    end

    if list.len == max_size
      expired_node = list.remove_tail
      nodes.delete(expired_node.data.key)
    end

    nodes[key] = list.unshift(KVPair.new(key, value))
    nil
  end

  def invalidate(key)
    return nil if nodes[key].nil?

    node = list.remove(nodes[key])
    nodes.delete(key)

    node.data.value
  end

  private
  attr_reader :list, :nodes, :max_size
end
