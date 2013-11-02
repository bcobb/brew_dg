require 'brew_dg/graph'
require 'brew_dg/graph_installation'

module BrewDG
  describe GraphInstallation do

    it 'is empty for an empty graph' do
      graph = Graph.new
      installation = GraphInstallation.new(graph)

      expect(installation.list).to eql([])
    end

    it 'is the single vertex for a one-vertex graph' do
      graph = Graph.new.tap do |g|
        g.add_vertex! 'a'
      end

      installation = GraphInstallation.new(graph)

      expect(installation.list).to eql(['a'])
    end

    it 'preserves vertex order' do
      graph = Graph.new.tap do |g|
        g.add_vertex! 'a'
        g.add_vertex! 'b'
      end

      installation = GraphInstallation.new(graph)

      expect(installation.list).to eql(['a', 'b'])
    end

    it 'moves from neighborhood to neighborhood from the bottom up' do 
      graph = Graph.new.tap do |g|
        g.add_vertices! 'a', 'b', 'c', 'd', 'e'
        g.add_edge! 'a', 'b'
        g.add_edge! 'b', 'c'
        g.add_edge! 'b', 'e'
        g.add_edge! 'e', 'd'
      end

      installation = GraphInstallation.new(graph)

      expect(installation.list).to eql(['c', 'd', 'e', 'b', 'a']);
    end

    it 'does not duplicate vertices' do
      graph = Graph.new.tap do |g|
        g.add_vertices! 'a', 'b', 'c'
        g.add_edge! 'a', 'b'
        g.add_edge! 'c', 'b'
      end

      installation = GraphInstallation.new(graph)

      expect(installation.list).to eql(['b', 'a', 'c'])
    end

  end
end
