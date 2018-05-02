module QL
  # For a human player
  class HumanPlayer
    property location : Array(Int32)

    def initialize
      @location = [0, 0]
    end

    def get_input
      input = STDIN.raw &.read_char
      case input
      when 'a'
        return :left
      when 'd'
        return :right
      when 'w'
        return :up
      when 's'
        return :down
      when 'q'
        return :quit
      else
        return :none
      end
    end

    def move_to(location : Array(Int32))
      @location = location
    end
  end
end
