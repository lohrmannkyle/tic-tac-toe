# frozen_string_literal: true
require 'pry'

# Simple rendition of tic-tac-toe
class Game
  def initialize
    @board = Board.new(3, 3)
    @players = []
    @test = true
    start_match
  end

  def start_match
    add_players
    player = @players.sample
    player.move
    while @board.moves < @board.total_moves
      player = rotate(player)
      if winner?(player.move)
        puts "#{player.name} has won!"
        return
      end
    end
  end

  private

  def winner?(metrics)
    player = metrics[0]
    row = metrics[1]
    column = metrics[2]
    @board.check_row(row, player.symbol ) || @board.check_column(column, player.symbol) 
  end
    

  def rotate(player)
    @players.find_index(player) == 1 ? @players[0] : @players[1]
  end

  def add_players
    if @test
      player1 = Player.new('test', '*', @board)
      player2 = Player.new('prod', '!', @board)
      @players.push(player1)
      @players.push(player2)
      return
    else
      2.times do
        puts 'Enter player name: '
        name = gets.chomp
        puts 'Enter game piece: '
        symbol = gets.chomp
        @players.push(Player.new(name, symbol, @board))
      end
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
    row = -1
    column = -1
    until valid_move?(row, column)
      row = row_choice
      column = column_choice
    end
    @board.update(row, column, @symbol)
    [self, row, column]
  end

  def valid_move?(row, column)
    row.between?(0, @board.width - 1) && column.between?(0, @board.height - 1) && @board.check_index(row, column)
  end

  def row_choice
    puts 'Row: '
    row = gets.chomp.to_i - 1
  end

  def column_choice
    puts 'Column: '
    column = gets.chomp.to_i - 1

  end
end

# State of the game board
class Board
  attr_reader :moves, :total_moves, :height, :width, :board

  def initialize(height, width)
    @height = height
    @width = width
    @board = Array.new(@height) { Array.new(@width, '-') }
    @total_moves = @width * @height
    @moves = 0
  end

  def check_index(row, column)
    binding.pry
    valid = @board[row][column] == '-'
    unless valid
      puts "Board spot already taken, choose again."
    end
    valid
  end

  def check_row(row, symbol)
    @board[row].count(symbol) == @width
  end

  def check_column(column, symbol)
    @board.each do |row|
      unless row[column] == symbol
        return false
      end
    end
    true
  end

  def update(row, column, symbol)
    @board[row][column] = symbol
    @moves += 1
    puts 'Please enter valid row/column index'
    puts self
  end

  def to_s
    @board.each { |row| p row }
  end
end

game1 = Game.new
