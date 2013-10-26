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

      lonely_nodes = vertices.select do |vertex|
        in_degree(vertex).zero? && out_degree(vertex).zero?
      end

      lonely_nodes.each do |node|
        if node.name == 'node'
          visualization.add_nodes('nodejs')
        else
          visualization.add_nodes(node.name)
        end
      end

      edges.reduce(visualization) do |visualization, edge|
        manifest = edge.to_a.last

        left, right = edge.to_a.first(2).map do |package|
          visualization.add_nodes(package.name)
        end

        edge_options = {
          required: { color: 'black' },
          recommended:  { color: 'gray20' },
          build: { color: 'cadetblue3' },
          optional: { style: 'dotted' }
        }.fetch(manifest.type)

        visualization.add_edges(left, right, edge_options)
        visualization
      end
    end

    def __getobj__ ; @graph ; end
    def __setobj__(new_graph) ; @graph = new_graph ; end

  end
end
