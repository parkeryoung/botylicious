module Botylicious
  class Threes
    include Cinch::Plugin
    match /start threes/, { method: :start }

    def start(m)
      paste = Pastie.create(generate_game)
      m.reply(paste.link)
    end

    def generate_game
      board = Board.new
      board.print
    end
  end

  class Board
    attr_accessor :plot
    def initialize
      self.plot = []
      generate
    end

    def point(x, y)
      self.plot[x][y]
    end

    def print
      string = ""
      plot.each do |line|
        string << line.map(&:value).join
        string << "\n"
      end
      string
    end

    def next_max
      plot.flatten.map(&:value).max
    end

    private
      def generate
        4.times do |x|
          self.plot[x] = []
          4.times do |y|
            self.plot[x] << Square.new(Square::STARTING_VALUES.sample, x, y)
          end
        end
      end
  end

  class Square
    attr_accessor :value, :x, :y
    VALUES = ["X", 1, 2, 3, 6, 12, 24, 48, 96, 192, 384, 768, 1536, 3072]
    STARTING_VALUES = VALUES.first(4)
    DIRECTIONS = {
      left: { x: -1, y:0 },
      right: { x: 1, y:0 },
      up: { x: 0, y: -1 },
      down: { x: 0, y: 1 }
    }

    def initialize(value, x, y)
      self.value = value
      self.x = x
      self.y = y
    end

    def combine(direction)
      move_to = DIRECTIONS[direction]
    end
  end
end
