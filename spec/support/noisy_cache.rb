require 'delegate'

module BrewDG

  class NoisyCache < Delegator

    def initialize(cache = {})
      super
      @cache = {}
      @noise_maker = Kernel.method(:puts)
    end

    def __getobj__ ; @cache ; end
    def __setobj__(new_cache) ; @cache = new_cache ; end

    def fetch(*args, &block)
      miss = false

      noisy_block = Proc.new do |*block_args| 
        miss = true
        block.call(*block_args)
      end

      super(*args, &noisy_block).tap do
        key = args.first

        if miss
          message = "#{key}: cache miss"
        else
          message = "#{key}: cache hit"
        end

        @noise_maker.call(message)
      end
    end

    def store(*args)
      super.tap do
        key = args.first
        @noise_maker.call "#{key}: warming cache"
      end
    end

  end

end
