require 'brew_dg/library'
require 'brew_dg/option_parser'

module BrewDG
  class CLI

    def initialize(argv, stdout = STDOUT, stderr = STDERR, kernel = Kernel)
      @argv = argv
      @stdout = stdout
      @stderr = stderr
      @kernel = kernel
      @configuration = OptionParser.new.parse(@argv)
    end

    attr_reader :configuration

    def execute!

    end

  end
end
