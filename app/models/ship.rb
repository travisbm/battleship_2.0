class Ship
  attr_reader :size, :type, :count
  
  def initialize(size, type, count)
    @size  = size
    @type  = type
    @count = count
  end
end
