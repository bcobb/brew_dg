module BrewDG
  class GraphInstallation

    attr_reader :graph

    def initialize(graph)
      @graph = graph
    end

    def list
      graph.vertices.map { |vertex| for_vertex(vertex) }.flatten.uniq
    end

    private

    def for_vertex(vertex)
      if graph.neighborhood(vertex, :out).size.zero?
        [vertex]
      else
        dependency_order = graph.neighborhood(vertex, :out).map do |dependency|
          for_vertex(dependency)
        end

        dependency_order + [vertex]
      end
    end

  end
end
