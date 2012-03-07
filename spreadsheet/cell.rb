require 'set'

# children are cells that depend on you
# parents are cells that you depend on
# after updating a cell, we add/remove the cell from its parents' children
# we check for cycles by making sure none of our new parents' ancestors
#  is the current cell
class Cell

  attr_reader :val, :parents, :children

  def initialize
    @children = Set.new
    @parents = Set.new
    @val = 1
  end

  def update(expr)
    new_parents = get_new_parents(expr)

    if cycle_formed?(new_parents)
      raise "cycle formed"
    end

    notify_parents(new_parents)
    @parents = new_parents

    @expr = expr

    update_val
    @val
  end

  def get_new_parents(expr)
    expr.select { |arg| arg.cell_ref }.collect { |ref| ref.val }.to_set
  end

  def cycle_formed?(new_parents)
    (new_parents - @parents).any? do |p|
      p.ancestor_include? self
    end
  end

  def ancestor_include?(c)
    (@parents.include? c) || @parents.any? { |p| p.ancestor_include? c }
  end

  def notify_parents(new_parents)
    # Detach from old parents
    (@parents - new_parents).each do |p|
      p.remove_child self
    end

    # Add new parents
    (new_parents - @parents).each do |p|
      p.add_child self
    end
  end

  def remove_child(c)
    @children.subtract(c)
  end

  def add_child(c)
    @children.add(c)
  end

  def update_val
    stack = []
    @expr.each do |arg|
      apply(arg, stack)
    end
    @val = stack[0]
    @children.each { |c| c.update_val }
  end

  def apply(arg, stack)
    if arg.number
      stack.push(arg.val)
    elsif arg.cell_ref
      stack.push(arg.val.val)
    elsif arg.operator
      operands = []
      arg.arity.times do
        operands.unshift stack.pop
      end
      stack.push arg.val.call(*operands)
    end
  end

end
