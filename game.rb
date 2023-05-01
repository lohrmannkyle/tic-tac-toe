# frozen_string_literal: true
require 'pry'
# Simple rendition of tic-tac-toe
class Game
  def initialize
    @board = Board.new(3,3)
    @players = []
    start_match
  end

  def start_match
    add_players
    player = @players.sample
    player.move
    while @board.moves < @board.total_moves
      player = rotate(player)
      player.move
    end
  end

  private

  def rotate(player)
    @players.find_index(player) == 1 ? @players[0] : @players[1]
  end

  def add_players
    2.times do
      puts 'Enter player name: '
      name = gets.chomp
      puts 'Enter game piece: '
      symbol = gets.chomp
      @players.push(Player.new(name, symbol, @board))
    end
  end
end

# One of the two players
class Player
  attr_reader :name, :symbol

  def initialize(name, symbol, board)
    @name = name
    @symbol = symbol
    @board = board
    @winner = false
  end

  def move
    puts @name
    @board.update(row_choice, column_choice, @symbol)
  end

  def row_choice
    row = -1
    until row.between?(0,@board.height)
      puts 'Row: '
      row = gets.chomp.to_i
    end
    puts row
  end

  def column_choice
    column = -1
    until column.between?(0, @board.width)
      puts 'Column: '
      column = gets.chomp.to_i
    end
    puts column
  end
end

# State of the game board
class Board
  attr_reader :moves, :total_moves, :height, :width

  def initialize(height, width)
    @height = height
    @width = width
    @board = Array.new(@height) { Array.new(@width, 0) }
    @total_moves = @width * @height
    @moves = 0
  end

  def update(row, column, symbol)
    binding.pry
    @board[row][column] = symbol
    @moves += 1
  
    puts "Please enter valid row/column index"
    puts self
  end

  def to_s
    @board.each { |row| p row }
  end
end

game1 = Game.new
