require 'delegate'

module BrewDG
  class QueryableDependencies < Delegator

    def initialize(dependency_manifests = [])
      super
      @dependency_manifests = dependency_manifests
    end

    def build
      of_type(:build)
    end

    def required
      of_type(:required)
    end

    def recommended
      of_type(:recommended)
    end

    def optional
      of_type(:optional)
    end

    def of_type(type)
      __getobj__.find { |d| d.type == type } ||
        DependencyManifest.new(type: type)
    end

    def __getobj__
      @dependency_manifests
    end

    def __setobj__(new_dependency_manifests)
      @dependency_manifests = new_dependency_manifests
    end

  end
end
