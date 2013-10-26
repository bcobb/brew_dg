require 'brew_dg'

describe "homebrew's output" do

  before(:all) do
    @library = BrewDG::Library.new
  end

  def library ; @library ; end

  it "can determine a package's build dependencies" do
    package = library.package('postgis')

    known_build_dependencies = %w(automake libtool gpp)
    build_manifest = package.dependencies.build
    build_dependencies = build_manifest.dependencies.map(&:name)

    expect(Set.new(known_build_dependencies)).
      to eql(Set.new(build_dependencies))
  end

  it "can determine a package's required dependencies" do
    package = library.package('postgis')

    known_required_dependencies = %w(postgresql proj geos json-c gdal)
    required_manifest = package.dependencies.required
    required_dependencies = required_manifest.dependencies.map(&:name)

    expect(Set.new(known_required_dependencies)).
      to eql(Set.new(required_dependencies))
  end

  it "can determine a package's recommended dependencies" do
    package = library.package('sqlite')

    known_recommended_dependencies = %w(readline)
    recommended_manifest = package.dependencies.recommended
    recommended_dependencies = recommended_manifest.dependencies.map(&:name)

    expect(Set.new(known_recommended_dependencies)).
      to eql(Set.new(recommended_dependencies))
  end

  it "can determine a package's optional dependencies" do
    package = library.package('nginx')

    known_optional_dependencies = %w(passenger)
    optional_manifest = package.dependencies.optional
    optional_dependencies = optional_manifest.dependencies.map(&:name)

    expect(Set.new(known_optional_dependencies)).
      to eql(Set.new(optional_dependencies))
  end

end
