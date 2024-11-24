# class LFUCache
#   Node = Struct.new(:key, :value, :freq)

#   def initialize(capacity)
#     @capacity = capacity
#     @cache = {}
#     @freq_map = Hash.new { |h, k| h[k] = [] }
#     @min_freq = 0
#     @hit_count = 0
#     @create_count = 0
#   end

#   def get(key)
#     if @cache.key?(key)
#       @hit_count += 1
#       puts "Cache hit for key: #{key}. Hits: #{@cache[key].freq}"
#       node = @cache[key]
#       update_freq(node)
#       node.value
#     else
#       puts "Cache miss for key: #{key}"
#       nil
#     end
#   end

#   def put(key, value)
#     return if @capacity == 0

#     if @cache.key?(key)
#       node = @cache[key]
#       node.value = value
#       update_freq(node)
#     else
#       evict if @cache.size >= @capacity
#       node = Node.new(key, value, 1)
#       @cache[key] = node
#       @freq_map[1] << node
#       @min_freq = 1
#       @create_count += 1
#       puts "Cache created for key: #{key}. Current cache size: #{@create_count}"
#     end
#   end

#   private

#   def update_freq(node)
#     @freq_map[node.freq].delete(node)
#     @freq_map.delete(node.freq) if @freq_map[node.freq].empty?

#     node.freq += 1
#     @freq_map[node.freq] << node

#     @min_freq += 1 if @freq_map[@min_freq].empty?
#   end

#   def evict
#     node = @freq_map[@min_freq].shift
#     puts "Evicting key: #{node.key} with frequency: #{node.freq}"
#     @cache.delete(node.key)
#     @freq_map.delete(@min_freq) if @freq_map[@min_freq].empty?
#   end
# end
