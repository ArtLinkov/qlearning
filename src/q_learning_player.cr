module QL
  # For the AI player
  class QLPlayer
    property location : Array(Int32), qtable : Hash(Array(Int32), Array(Float64))
    @old_state : Array(Int32)
    @old_action_index : Int32

    # @first_run : Bool

    def initialize(@learning_rate : Float64 = 0.2, @discount : Float64 = 0.9, @epsilon : Float64 = 0.1)
      # @first_run = true
      @location = [0, 0]                               # Starting location in the game
      @actions = [:left, :right, :up, :down]           # All possible actions of the player
      @old_state = @location.clone                     # Previous location, at the beggining is equal to starting location
      @old_action_index = rand(0..(@actions.size - 1)) # Previous action, first action is random
      @reward = 0.0
      @goal = [0, 0]
      @pit1 = [0, 0]
      @pit2 = [0, 0]

      # Initialize an empty q-table
      @qtable = Hash(Array(Int32), Array(Float64)).new
    end

    def game_init(@game : Game)
      @location = @game.not_nil!.start_position.clone
      @old_state = @location.clone
      @goal = @game.not_nil!.cheese.clone
      @pit1 = @game.not_nil!.pit1.clone
      @pit2 = @game.not_nil!.pit2.clone
    end

    def get_input
      # Pause to make sure we can follow the AI player movement
      sleep(0.04)

      # New state is equal to player position
      current_state = @location.clone

      # Add the new state if it's not in the table
      @qtable[current_state] = (Array(Float64).new(@actions.size) { rand(0.0..1.0) }) unless @qtable[current_state]?

      # First we need to evaluate the previous action if it was good or not
      @reward = 0.0
      case current_state
      when @goal
        @reward = 1.0
      when @pit1 || @pit2
        @reward = -1.0
      end

      # Optional: Update the utility of prev state and action chosen with cost of action
      @qtable[@old_state][@old_action_index] *= 0.95 # Prev utility value

      # Choose action based on best next reward estimation from current state (or random)
      if rand(0.0..1.0) <= @epsilon
        # Select random action
        action_index = rand(0..(@actions.size - 1))
      else
        # Select next action based on q-table values
        action_index = @qtable[current_state].each_with_index.max[1]
      end

      # Current utility of state and previous action
      q_s_a = @qtable[@old_state][@old_action_index].clone

      # Utility of the next state based on chosen action
      next_q_s_a = @qtable[current_state][action_index].clone

      # Update current utility value using future utility value
      @qtable[@old_state][@old_action_index] += @learning_rate*(@reward + @discount*next_q_s_a - q_s_a)

      # Capture current state and action
      @old_state = current_state
      @old_action_index = action_index

      # Take action
      return @actions[action_index]
    end
  end
end
