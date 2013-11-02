require 'delegate'
require 'graphviz'
require 'plexus'

module BrewDG
  class Graph < ::Plexus::Digraph

    def visualization
      visualization = GraphViz.new(:G)

      isolated_vertices.each do |vertex|
        visualization.add_nodes(vertex.to_s)
      end

      edges.reduce(visualization) do |visualization, edge|
        manifest = edge.to_a.last

        left, right = edge.to_a.first(2).map do |package|
          visualization.add_nodes(package.to_s)
        end

        visualization.add_edges(left, right, edge_options(manifest))
        visualization
      end
    end

    def isolated_vertices
      vertices.select do |vertex|
        in_degree(vertex).zero? && out_degree(vertex).zero?
      end
    end

    private
   
    def edge_options(manifest)
      if manifest
        type = manifest.type

        edge_options = {
          recommended:  { arrowhead: 'empty' },
          optional: { style: 'dotted' },
          build: { style: 'dotted', arrowhead: 'tee' }
        }.fetch(type, {})
      else
        {}
      end
    end

  end
end
