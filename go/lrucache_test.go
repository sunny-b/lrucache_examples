package lrucache

import (
	"sync"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGet(t *testing.T) {
	t.Run("get key from empty cache", func(t *testing.T) {
		cache := New(1)
		value := cache.Get("key")

		assert.Nil(t, value)
	})

	t.Run("get key from non-empty cache", func(t *testing.T) {
		cache := New(1)
		cache.Set("foo", "bar")
		value := cache.Get("foo")

		assert.Equal(t, "bar", value.(string))
	})
}

func TestSet(t *testing.T) {
	t.Run("set value in cache with space", func(t *testing.T) {
		cache := New(1)
		value := cache.Set("foo", "bar")

		assert.Nil(t, value)
	})

	t.Run("set value in cache with no space", func(t *testing.T) {
		cache := New(1)
		cache.Set("foo", "bar")
		value := cache.Set("baz", "bak")

		assert.Equal(t, "bar", value)
	})

	t.Run("multiple goroutines setting values", func(t *testing.T) {
		cache := New(1)

		var wg sync.WaitGroup
		for i := 0; i < 5; i++ {
			wg.Add(1)

			go func(val int) {
				defer wg.Done()
				cache.Set("foo", val)
			}(i)
		}

		wg.Wait()

		value := cache.Get("foo")

		assert.NotNil(t, value)
	})
}

func TestInvalidate(t *testing.T) {
	t.Run("invalidate in use key", func(t *testing.T) {
		cache := New(1)
		cache.Set("foo", "bar")
		assert.Equal(t, "bar", cache.Get("foo").(string))

		cache.Invalidate("foo")

		assert.Nil(t, cache.Get("foo"))
	})
}
