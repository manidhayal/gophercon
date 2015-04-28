class BreathFirstSearch
  def initialize(graph, source_node)
    @graph = graph
    @node = source_node
    @visited = []
    @edge_to = {}

    bfs(source_node)
  end

  def shortest_path_to(node)
    return unless has_path_to?(node)
    path = []

    while(node != @node) do
      path.unshift(node)
      node = @edge_to[node]
    end

    path.unshift(@node)
  end

  private
  def bfs(node)
    queue = []
    queue << node
    @visited << node

    while queue.any?
      current_node = queue.shift
      @graph.adjacents(current_node).each do |adjacent_node|
        next if @visited.include?(adjacent_node)
        queue << adjacent_node
        @visited << adjacent_node
        @edge_to[adjacent_node] = current_node
      end
    end
  end

  def has_path_to?(node)
    @visited.include?(node)
  end
end