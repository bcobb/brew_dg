require 'brew_dg/dependency_manifest'
require 'brew_dg/queryable_dependencies'

module BrewDG

  describe QueryableDependencies do

    it 'knows which manifest is the build manifest' do
      build = DependencyManifest.new(type: :build)
      required = DependencyManifest.new(type: :required)

      queryable = QueryableDependencies.new([build, required])

      expect(queryable.build).to eql(build)
    end

    it 'knows which manifest is the required manifest' do
      build = DependencyManifest.new(type: :build)
      required = DependencyManifest.new(type: :required)

      queryable = QueryableDependencies.new([build, required])

      expect(queryable.required).to eql(required)
    end

    it 'knows which manifest is the recommended manifest' do
      optional = DependencyManifest.new(type: :optional)
      recommended = DependencyManifest.new(type: :recommended)

      queryable = QueryableDependencies.new([optional, recommended])

      expect(queryable.recommended).to eql(recommended)
    end

    it 'knows which manifest is the optional manifest' do
      optional = DependencyManifest.new(type: :optional)
      recommended = DependencyManifest.new(type: :recommended)

      queryable = QueryableDependencies.new([optional, recommended])

      expect(queryable.optional).to eql(optional)
    end

  end

end
