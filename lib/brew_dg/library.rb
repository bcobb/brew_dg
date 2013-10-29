require 'brew_dg/dependency_manifest'
require 'brew_dg/graph'
require 'brew_dg/package'
require 'brew_dg/queryable_dependencies'

module BrewDG
  class Library

    def initialize(options = {})
      @package_cache = options.fetch(:package_cache, {})
      @packages = options.fetch(:packages) do
        %x(brew list).lines.map(&:strip)
      end
      @relevant_dependency_types = options.fetch(:relevant_dependency_types) do
        [:required, :recommended]
      end
    end

    def graph
      @packages.reduce(Graph.new) do |graph, name|
        graph.add_edges!(*subgraph(name).edges)
      end
    end

    def subgraph(name)
      package = package(name)

      Graph.new.tap do |graph|
        graph.add_vertex!(package)

        manifests = @relevant_dependency_types.map do |type|
          package.dependencies.of_type(type)
        end

        manifests.reduce(graph) do |manifest_graph, manifest|
          manifest.dependencies.reduce(manifest_graph) do |subgraph, dependency|
            subgraph.add_edge!(package, dependency, manifest)
            subgraph.add_edges!(*subgraph(dependency.name).edges)
          end
        end
      end
    end

    def package(name)
      @package_cache.fetch(name) do
        manifests = DependencyManifest.for_package(name)

        manifests.map! do |manifest|
          packages = manifest.dependencies.map(&method(:package))

          DependencyManifest.new(type: manifest.type, dependencies: packages)
        end

        dependencies = QueryableDependencies.new(manifests)

        Package.new(name: name, dependencies: dependencies).tap do |package|
          @package_cache.store(name, package)
        end
      end
    end

    def installation_order
      order = graph.vertices.map do |package|
        installation_order_of(package)
      end

      # Array#uniq which will preserve the first of any repeated elements. If
      # Array#uniq does this, I would prefer to not rely on that implementation
      # detail.
      order.flatten.reduce([]) do |install, package|
        install | [package.name]
      end
    end

    def installation_order_of(package)
      if graph.neighborhood(package, :out).size.zero?
        [package]
      else
        dependency_order = graph.neighborhood(package, :out).map do |dependency|
          installation_order_of(dependency)
        end

        dependency_order + [package]
      end
    end

  end
end
