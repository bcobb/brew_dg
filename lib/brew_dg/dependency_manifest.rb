require 'virtus'

module BrewDG
  class DependencyManifest
    include Virtus.value_object

    DEPENDENCY_TYPES = %w(Build Required Recommended Optional)

    def self.for_package(package)
      %x(brew info #{package}).lines.map(&method(:from_output)).compact
    end

    def self.from_output(line)
      type_match = line.match(/^(\w+):/)
      type = type_match && type_match.captures.first

      if DEPENDENCY_TYPES.include?(type)
        manifest_header = "#{type}: "
        manifest_parts = line.split(manifest_header)

        if manifest_parts.size == 2
          manifest_body = manifest_parts.last
          dependencies = manifest_body.split(', ').map(&:strip)
        else
          dependencies = []
        end

        new(type: type.downcase.intern, dependencies: dependencies)
      end
    end

    values do
      attribute :type, Symbol
      attribute :dependencies, Array, default: []
    end

  end
end
