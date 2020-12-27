import unittest
from lrucache import LRUCache 

class TestLRUCache(unittest.TestCase):
    def test_get_empty(self):
        cache = LRUCache()
        self.assertEqual(cache.get('foo'), None)

    def test_set_empty(self):
        cache = LRUCache()
        cache.set('foo', 10)
        self.assertEqual(cache.get('foo'), 10)

    def test_set_replace(self):
        cache = LRUCache()
        cache.set('foo', 10)
        cache.set('foo', 20)
        self.assertEqual(cache.get('foo'), 20)

    def test_set_full(self):
        cache = LRUCache(1)
        cache.set('foo', 10)
        cache.set('bar', 20)
        self.assertEqual(cache.get('foo'), None)
        self.assertEqual(cache.get('bar'), 20)

    def test_get_move_front(self):
        cache = LRUCache(2)
        cache.set('foo', 10)
        cache.set('bar', 20)
        cache.get('foo')
        cache.set('baz', 30)
        self.assertEqual(cache.get('foo'), 10)
        self.assertEqual(cache.get('bar'), None)
        self.assertEqual(cache.get('baz'), 30)

    def test_set_move_front(self):
        cache = LRUCache(2)
        cache.set('foo', 10)
        cache.set('bar', 20)
        cache.set('foo', 40)
        cache.set('baz', 30)
        self.assertEqual(cache.get('foo'), 40)
        self.assertEqual(cache.get('bar'), None)
        self.assertEqual(cache.get('baz'), 30)

    def test_invalidate_empty(self):
        cache = LRUCache(2)
        self.assertEqual(cache.invalidate('foo'), None)

    def test_invalidate(self):
        cache = LRUCache(2)
        cache.set('foo', 10)
        self.assertEqual(cache.get('foo'), 10)
        self.assertEqual(cache.invalidate('foo'), 10)
        self.assertEqual(cache.get('foo'), None)
        

if __name__ == '__main__':
    unittest.main()
