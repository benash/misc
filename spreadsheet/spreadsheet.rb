require './cell'
require './cell_arg'

class Spreadsheet

  attr_reader :w, :h
  CELL_REGEXP = Regexp.new('^([A-Z])([1-9]\d*)$')

  def initialize(w, h)
    @w, @h = w, h
    @cells = Array.new(h) { Array.new(w) { Cell.new } }
  end

  def get(x, y)
    @cells[y][x].val
  end

  def set(x, y, expr)
    @cells[y][x].update(add_cell_refs(expr))
  end

  # Takes string like "A1 B2 / 2 +" and returns array of CellArgs,
  # [#<Cell 0x1243>, #<Cell 0xA4D2>, '/', '2', '+']
  def add_cell_refs(expr)
    expr.split(' ').collect do |arg|
      CellArg.new(cell_ref(arg) || arg)
    end
  end

  def cell_ref(alpha_num)
     if match = CELL_REGEXP.match(alpha_num)
       row = match[1].ord - 'A'.ord
       col = match[2].to_i - 1
       @cells[row][col]
     end
  end

end
