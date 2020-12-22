require_relative 'lrucache'
require 'test/unit'

class TestLRUCache < Test::Unit::TestCase
  def test_set
    cache = LRUCache.new(1)
    assert_equal(nil, cache.set(:test, 1))
  end

  def test_get
    cache = LRUCache.new(1)
    assert_equal(nil, cache.set(:test, 1))
    assert_equal(1, cache.get(:test))
  end

  def test_set_full_cache
    cache = LRUCache.new(1)
    assert_equal(nil, cache.set(:test, 1))
  end

  def test_set_exceptions
    assert_raise { LRUCache.new(0) }
  end

  def test_set_replace_value
    cache = LRUCache.new(1)
    cache.set(:test, 1)
    cache.set(:test, 2)

    assert_equal(2, cache.get(:test))
  end

  def test_set_expiring
    cache = LRUCache.new(2)
    cache.set(:foo, 1)
    cache.set(:bar, 2)
    cache.get(:foo)
    cache.set(:baz, 3)

    assert_equal(nil, cache.get(:bar))
    assert_equal(3, cache.get(:baz))
    assert_equal(1, cache.get(:foo))
  end

  def test_invalidate
    cache = LRUCache.new(2)
    assert_equal(nil, cache.invalidate(:foo))
    cache.set(:foo, 1)
    assert_equal(1, cache.invalidate(:foo))
  end
end

class TestLinkedList < Test::Unit::TestCase
  def test_unshift
    list = DoublyLinkedList.new
    list.unshift(1)
    assert_equal(1, list.send(:root).next.val)
    assert_equal(1, list.send(:root).prev.val)
  end

  def test_unshift_multi
    list = DoublyLinkedList.new
    list.unshift(1)
    list.unshift(2)
    assert_equal(2, list.send(:root).next.val)
    assert_equal(1, list.send(:root).prev.val)
  end

  def test_move_front
    list = DoublyLinkedList.new
    node = list.unshift(1)
    list.unshift(2)
    assert_equal(2, list.send(:root).next.val)
    assert_equal(1, list.send(:root).prev.val)

    list.move_front(node)
    assert_equal(2, list.send(:root).prev.val)
    assert_equal(1, list.send(:root).next.val)
  end
end
