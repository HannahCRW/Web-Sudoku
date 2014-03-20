require 'sinatra'
require_relative './lib/sudoku'
require_relative './lib/cell'
 
enable :sessions
 
def random_sudoku
  seed = (1..9).to_a.shuffle + Array.new(81-9, 0)
  sudoku = Sudoku.new(seed.join)
  sudoku.solve!
  sudoku.to_s.chars
end

# this method removes some digits from the solution to create a puzzle
def puzzle(sudoku)
  sudoku.map { |element| rand > 0.37 ? ' ' : element }
end

get '/' do
  sudoku = random_sudoku
  session[:solution] = sudoku
  @current_solution = puzzle(sudoku)
  erb :index
end

post '/' do
  cells = params["cell"]
  session[:current_solution] = cells.map{|value| value.to_i }.join
  session[:check_solution] = true
  redirect to("/")
end

get '/solution' do
  @current_solution = session[:solution]
  erb :index
end