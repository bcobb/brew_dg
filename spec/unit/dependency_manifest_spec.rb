require 'brew_dg/dependency_manifest'

module BrewDG
  describe DependencyManifest do

    it 'infers its type from the beginning of the line' do
      manifest = "Required: json-c"
      dependency_manifest = DependencyManifest.from_output(manifest)

      expect(dependency_manifest.type).to eql(:required)
    end

    it 'knows that dependencies are comma-delimited after the type' do
      manifest = "Required: json-c, proj, geos"
      dependency_manifest = DependencyManifest.from_output(manifest)

      expect(dependency_manifest.dependencies).
        to eql(%w(json-c proj geos))
    end

    it 'strips newlines from dependencies' do
      manifest = "Required: json-c, proj, geos\n"
      dependency_manifest = DependencyManifest.from_output(manifest)

      expect(dependency_manifest.dependencies).
        to eql(%w(json-c proj geos))
    end

    it 'does not care if there are dependencies on the line' do
      manifest = "Required:"
      dependency_manifest = DependencyManifest.from_output(manifest)

      expect(dependency_manifest.dependencies).to eql([])
    end

    it 'can determine if a line is a dependency' do
      invalid_manifests = [
        ": json-c, proj, geos",
        "Something: one, two, three",
        "Nothing",
        "Ha:",
        ""
      ]

      valid_manifests = [
        "Build:",
        "Recommended:",
        "Required:",
        "Optional:",
        "Optional: passenger",
        "Build: libtool, gcc",
        "Required: geos, proj",
        "Recommended: ossp-uuid"
      ]

      invalid_manifests.map! { |manifest| DependencyManifest.from_output(manifest) }
      valid_manifests.map! { |manifest| DependencyManifest.from_output(manifest) }

      expect(invalid_manifests.any?).to be_false
      expect(valid_manifests.all?).to be_true
    end

  end
end
