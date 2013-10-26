require 'brew_dg/queryable_dependencies'
require 'virtus'

module BrewDG
  class Package
    include Virtus.value_object

    values do
      attribute :name, String
      attribute :dependencies, QueryableDependencies
    end

  end
end

