require 'brew_dg/queryable_dependencies'

module BrewDG

  describe QueryableDependencies do

    it 'knows which manifest is the build manifest' do
      build = double('DependencyManifest', :type => :build)
      required = double('DependencyManifest', :type => :required)

      queryable = QueryableDependencies.new([build, required])

      expect(queryable.build).to eql(build)
    end

    it 'knows which manifest is the required manifest' do
      build = double('DependencyManifest', :type => :build)
      required = double('DependencyManifest', :type => :required)

      queryable = QueryableDependencies.new([build, required])

      expect(queryable.required).to eql(required)
    end

    it 'knows which manifest is the recommended manifest' do
      optional = double('DependencyManifest', :type => :optional)
      recommended = double('DependencyManifest', :type => :recommended)

      queryable = QueryableDependencies.new([optional, recommended])

      expect(queryable.recommended).to eql(recommended)
    end

    it 'knows which manifest is the optional manifest' do
      optional = double('DependencyManifest', :type => :optional)
      recommended = double('DependencyManifest', :type => :recommended)

      queryable = QueryableDependencies.new([optional, recommended])

      expect(queryable.optional).to eql(optional)
    end

  end

end
