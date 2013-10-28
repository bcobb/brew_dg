require 'optparse'

module BrewDG
  class OptionParser

    def initialize
      @options = {}
    end

    attr_reader :options

    def parse(args)
      tap { parser.parse!(Array(args)) }
    end

    def parser
      all_types = [:required, :recommended, :optional, :build]

      ::OptionParser.new do |parser|
        parser.on('-a') do |a|
          update(:types, all_types) if a
        end

        parser.on('-t type1,type2', Array) do |types|
          types = Array(types).map(&:strip).map(&:downcase).map(&:intern)

          update(:types, types)
        end

        parser.on('-o [file]') do |file|
          destination(file)
        end

        parser.on('-O [file]') do |file|
          destination(file)
          update(:inverted, true)
        end
      end
    end

    def update(key, val)
      options.update(key => val) do |_, oldval, _|
        oldval
      end
    end

    def destination(file)
      if file
        file = File.expand_path(file)

        if File.directory?(file)
          file = File.join(file, 'library.png')
        end
      end

      update(:destination, file || STDOUT)
    end

  end
end
