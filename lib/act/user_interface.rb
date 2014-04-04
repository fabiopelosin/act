module Act
  # Manages the UI output.
  #
  module UserInterface
    def self.puts(message)
      STDOUT.puts message
    end

    def self.warn(message)
      STDERR.puts message
    end
  end

  UI = UserInterface
end
