require 'delegate'
require 'graphviz'
require 'plexus'

module BrewDG
  class Graph < Delegator

    def self.taps(*methods)
      methods.each do |method|
        define_method(method) do |*args, &block|
          tap { super(*args, &block) }
        end
      end
    end

    def self.shims(*methods)
      methods.each do |method|
        define_method(method) do |*args, &block|
          self.class.new(super(*args, &block))
        end
      end
    end

    def initialize(graph = nil)
      super
      @graph = graph || Plexus::Digraph.new
    end

    taps :add_vertex!, :add_edge!, :add_edges!
    shims :reversal

    def visualization
      visualization = GraphViz.new(:G)

      isolated_vertices.each do |vertex|
        visualization.add_nodes(vertex.name)
      end

      edges.reduce(visualization) do |visualization, edge|
        manifest = edge.to_a.last

        left, right = edge.to_a.first(2).map do |package|
          visualization.add_nodes(package.name)
        end

        visualization.add_edges(left, right, edge_options(manifest.type))
        visualization
      end
    end

    def isolated_vertices
      vertices.select do |vertex|
        in_degree(vertex).zero? && out_degree(vertex).zero?
      end
    end

    def __getobj__ ; @graph ; end
    def __setobj__(new_graph) ; @graph = new_graph ; end

    private
   
    def edge_options(type)
      edge_options = {
        recommended:  { arrowhead: 'empty' },
        optional: { style: 'dotted' },
        build: { style: 'dotted', arrowhead: 'tee' }
      }.fetch(type, {})
    end

  end
end
