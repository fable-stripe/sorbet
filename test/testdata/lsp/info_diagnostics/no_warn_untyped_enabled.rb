# typed: strict

# warn-untyped-values: false

extend T::Sig

sig { returns(Integer) }
def foo
  my_map = T.let({ foo: 1, bar: 'baz' }, T::Hash[Symbol, T.untyped])
  my_map[:foo]
end

sig { params(x: Integer, y: String).returns(Integer) }
def bar(x, y)
	if x > y.length
		x
	else
		y.length
	end
end

sig { returns(T.untyped) }
def baz
	T.let(5, T.untyped)
end

b = baz
  b.length
T.let(b, Integer) == 6