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
        [:build, :required, :recommended, :optional]
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

        manifests.reduce(graph) do |graph, manifest|
          manifest.dependencies.reduce(graph) do |graph, dependency|
            graph.add_edge!(package, dependency, manifest)
            graph.add_edges!(*subgraph(dependency.name).edges)
          end
        end
      end
    end

    def package(name)
      @package_cache.fetch(name) do
        manifests = %x(brew info #{name}).lines.map do |line|
          DependencyManifest.from_output(line)
        end

        manifests.compact!

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

  end
end
