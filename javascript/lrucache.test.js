const LRUCache = require('./lrucache')

test('cache get empty is null', () => {
	const cache = new LRUCache(1)
	expect(cache.get('test')).toBe(null)
})

test('cache set sets the value', () => {
	const cache = new LRUCache(1)
	cache.set('test', 10)
	expect(cache.get('test')).toBe(10)
})

test('cache set replaces old value', () => {
	const cache = new LRUCache(1)
	cache.set('test', 10)
	cache.set('test', 20)
	expect(cache.get('test')).toBe(20)
})

test('cache set in a full cache should remove last value', () => {
	const cache = new LRUCache(1)
	cache.set('foo', 10)
	cache.set('bar', 20)
	expect(cache.get('foo')).toBe(null)
	expect(cache.get('bar')).toBe(20)
})

test('cache get moves item to front', () => {
	const cache = new LRUCache(2)
	cache.set('foo', 10)
	cache.set('bar', 20)
	cache.get('foo')
	cache.set('baz', 30)
	expect(cache.get('bar')).toBe(null)
	expect(cache.get('baz')).toBe(30)
	expect(cache.get('foo')).toBe(10)
})

test('invalidate removes a key from the cache', () => {
	const cache = new LRUCache(2)
	cache.set('foo', 10)
	cache.set('bar', 20)
	expect(cache.get('foo')).toBe(10)
	expect(cache.get('bar')).toBe(20)
	cache.invalidate('bar')
	expect(cache.get('bar')).toBe(null)
})
