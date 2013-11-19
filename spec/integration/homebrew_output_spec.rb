require 'brew_dg'

module BrewDG
  describe DependencyManifest do

    it "can determine a package's build dependencies" do
      manifests = DependencyManifest.for_package('postgis')

      known_build_dependencies = %w(autoconf automake libtool gpp)
      build_manifest = manifests.find { |manifest| manifest.type == :build }
      build_dependencies = build_manifest.dependencies

      expect(Set.new(known_build_dependencies)).
        to eql(Set.new(build_dependencies))
    end

    it "can determine a package's required dependencies" do
      manifests = DependencyManifest.for_package('postgis')

      known_required_dependencies = %w(postgresql proj geos json-c gdal)
      required_manifest = manifests.find do |manifest|
        manifest.type == :required
      end
      required_dependencies = required_manifest.dependencies

      expect(Set.new(known_required_dependencies)).
        to eql(Set.new(required_dependencies))
    end

    it "can determine a package's recommended dependencies" do
      manifests = DependencyManifest.for_package('sqlite')

      known_recommended_dependencies = %w(readline)
      recommended_manifest = manifests.find do |manifest|
        manifest.type == :recommended
      end
      recommended_dependencies = recommended_manifest.dependencies

      expect(Set.new(known_recommended_dependencies)).
        to eql(Set.new(recommended_dependencies))
    end

    it "can determine a package's optional dependencies" do
      manifests = DependencyManifest.for_package('nginx')

      known_optional_dependencies = %w(passenger)
      optional_manifest = manifests.find do |manifest|
        manifest.type == :optional
      end
      optional_dependencies = optional_manifest.dependencies

      expect(Set.new(known_optional_dependencies)).
        to eql(Set.new(optional_dependencies))
    end

  end
end
