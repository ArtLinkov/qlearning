module QL
  class Game
    getter score : Int32, map_size : Array(Int32), start_position : Array(Int32)
    getter cheese : Array(Int32), pit1 : Array(Int32), pit2 : Array(Int32)
    property player : HumanPlayer | QLPlayer, quit : Bool

    @run : Int32
    @moves : Int32

    def initialize(@player : HumanPlayer | QLPlayer)
      @map_size = [12, 12]
      @start_position = [3, 3]
      @score = 0
      @cheese = [10, 10]
      @pit1 = [1, 1]
      @pit2 = [6, 5]
      @run = 0
      @moves = 0
      @quit = false

      new_run
    end

    def new_run
      @player.location = @start_position.clone
      @score = 0
      @run += 1
      @moves = 0
    end

    def run
      if @player.class == QL::HumanPlayer
        puts "What do you want to do? (a = left, d = right, w = up, s = down, q = quit)"
      end

      while @score < 5 && @score > -5
        draw
        gameloop

        if @moves == 100
          @score -= 1
          go_to_start
          @moves = 0
        end

        if @quit == true
          break
        end
      end

      # Draw one last time
      draw

      if @score == 5
        puts "\nWin in #{@moves} moves!"
        puts "Do you want to continue? (y/n)"
        key = STDIN.raw &.read_char
        if key == 'n'
          @quit = true
          return
        end
      else
        puts "\nYou lose... *sad trombone*"
        puts "Do you want to continue? (y/n)"
        key = STDIN.raw &.read_char
        if key == 'n'
          @quit = true
          return
        end
      end
    end

    def draw
      # Compute the map display
      map = Array(Array(Char)).new(@map_size[0]) { Array(Char).new(@map_size[1]) { '.' } }
      @map_size[0].times do |row|
        @map_size[1].times do |col|
          case [row, col]
          when [0, col]
            map[row][col] = '#'
          when [row, 0]
            map[row][col] = '#'
          when [(map_size[0] - 1), col]
            map[row][col] = '#'
          when [row, (map_size[1] - 1)]
            map[row][col] = '#'
          when @player.location
            map[row][col] = 'P'
          when @cheese
            map[row][col] = '@'
          when @pit1
            map[row][col] = 'x'
          when @pit2
            map[row][col] = 'x'
          else
            map[row][col] = ' '
          end
        end
      end
      map.each { |r| puts r.join }
      puts "Moves #{@moves} | Score #{@score} | Run #{@run} | Location: #{@player.location[0]},#{@player.location[1]}"
    end

    def gameloop
      move = @player.get_input
      @moves += 1

      case move
      when :left
        if @player.location[1] > 1
          @player.location[1] -= 1
        end
      when :right
        if @player.location[1] < (@map_size[1] - 2)
          @player.location[1] += 1
        end
      when :up
        if @player.location[0] > 1
          @player.location[0] -= 1
        end
      when :down
        if @player.location[0] < (@map_size[0] - 2)
          @player.location[0] += 1
        end
      when :quit
        @quit = true
      when :none
        # @moves -= 1
        puts("\nPlease choose a valid key.")
      end

      location = @player.location
      case location
      when @cheese
        @score += 1
        go_to_start
      when @pit1
        @score -= 1
        go_to_start
      when @pit2
        @score -= 1
        go_to_start
      end
    end

    def go_to_start
      @player.location = @start_position.clone
    end
  end
end
