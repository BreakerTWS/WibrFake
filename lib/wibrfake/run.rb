module WibrFakeOPT
    class Runner
        def self.runner(options)
            require_relative 'optionpr'
            WibrFake::ParseOPT.new(options)
        end
    end
end