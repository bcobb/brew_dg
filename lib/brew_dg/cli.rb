require 'brew_dg/library'
require 'brew_dg/option_parser'

module BrewDG
  class CLI

    def initialize(argv, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
      @argv = argv
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
      @configuration = OptionParser.new.parse(@argv).options

      if @argv.any?
        @packages = @argv
      end
    end

    attr_reader :configuration

    def execute!
      options = {}

      if configuration[:types]
        options.update(relevant_dependency_types: configuration[:types])
      end

      if @packages
        options.update(packages: @packages)
      end

      library = Library.new(options)

      if configuration[:destination]
        graph = library.graph.reversal

        if configuration[:inverted]
          visualization = graph.visualization
        else
          visualization = graph.reversal.visualization
        end

        visualization.output(png: configuration[:destination])
      else
        @stdout.puts library.installation_order.join(' ')
      end
    end

  end
end
