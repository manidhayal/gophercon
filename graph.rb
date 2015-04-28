class Graph
  attr_accessor :edges, :nodes
  
  def initialize()
    @nodes = {}
    @edges = []
  end

  def add_node(node)
    @nodes[node.name] ||= node
  end

  def get_node(name)
    @nodes[name]
  end

  def add_edge(node_a, node_b)
    if @edges.select{|e| e.node_a.name == node_a.name && e.node_b.name == node_b.name}.any? ||
       @edges.select{|e| e.node_b.name == node_a.name && e.node_a.name == node_b.name}.any?
       return
    end
    @edges.push(Edge.new(node_a, node_b))
  end

  def adjacents(node)
    @edges.select{|e| e.node_a.name == node.name}.map(&:node_b) +
    @edges.select{|e| e.node_b.name == node.name}.map(&:node_a)
  end
end