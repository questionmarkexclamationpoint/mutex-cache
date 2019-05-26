class MutexCache
  def initialize(timeout = 60.0)
    @mutexes = {}
    @init_times = {}
    @mutex = Mutex.new
    @timeout = timeout
    @running = true
    Thread.new do
      run
    end
    ObjectSpace.define_finalizer(self, ->{ @running = false })
  end

  def [](index)
    get_or_create(index)
  end

  def lock(index)
    get_or_create(index).lock
  end

  def locked?(index)
    m = @mutexes[index]
    ! m.nil? && m.locked?
  end

  def owned?(index)
    m = @mutexes[index]
    ! m.nil? && m.owned?
  end

  def sleep(index, timeout = nil)
    m = get_or_create(index)
    timeout.nil? ? m.sleep : m.sleep(timeout)
  end

  def synchronize(index, &block)
    get_or_create(index).synchronize(&block)
  end

  def try_lock(index)
    get_or_create(index).try_lock
  end

  def unlock(index)
    get_or_create(index).unlock
  end

  private

  def get_or_create(index)
    @mutex.synchronize do
      unless @mutexes.has_key?(index)
        @mutexes[index] = Mutex.new
        @init_times[index] = Time.now
      end
      @mutexes[index]
    end
  end

  def run
    while @running
      Kernel.sleep(@timeout)
      clean_cache
    end
  end

  def clean_cache
    @mutex.synchronize do
      @mutexes.each do |key, value|
        if ! value.locked? && Time.now - @init_times[key] >= @timeout
          @mutexes.delete(key)
          @init_times.delete(key)
        end
      end
    end
  end
end
