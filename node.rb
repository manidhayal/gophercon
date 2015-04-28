class Node
  attr_accessor :name, :adjacents

  def initialize(name)
    @name = name
  end

  def to_s
    @name
  end
end