class CellArg

  NUMBER = Regexp.new('[-+]?[0-9]*\.?[0-9]+')

  # operator table: <operator string> => [<operator proc>, <operator arity>]
  OPERATORS = { '+' => [:+.to_proc, 2], 
                '-' => [:-.to_proc, 2], 
                '*' => [:*.to_proc, 2], 
                '/' => [:/.to_proc, 2],
                '**' => [:**.to_proc, 2],
                '++' => [lambda {|x| x + 1 }, 1],
                '--' => [lambda {|x| x - 1 }, 1],
                }

  attr_reader :cell_ref, :number, :operator, :val, :arity

  def initialize(o)
    @cell_ref = false
    @number = false
    @operator = false

    if o.class.name != 'String'
      @cell_ref = true
      @val = o
    elsif NUMBER.match(o)
      @number = true
      @val = o.to_f
    elsif OPERATORS.include? o
      @operator = true
      @val = OPERATORS[o][0]
      @arity = OPERATORS[o][1]
    end
  end

end
