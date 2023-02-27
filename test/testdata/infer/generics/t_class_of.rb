# typed: true

# TODO(jez) Another consideration for all of this: having the constant literal
# `A` have type `T.class_of(A)[T.untyped]` is kind of like allowing `A` to
# simply not implement an abstract type, which is just like how it's bad that
# singleton class methods can be abstract.
#
# Maybe we should require non-fixed, invariant type members to be marked
# `abstract!`?
#

class Module
  include T::Sig
end

class A
  extend T::Sig
  extend T::Generic
  abstract!

  X = type_template

  sig {abstract.returns(X)}
  def self.foo; end

  sig {returns(Integer)}
  def instance_method; 0; end
end

class ChildA < A
  extend T::Sig
  extend T::Generic

  X = type_template

  sig {override.returns(X)}
  def self.foo; raise; end
end

sig do
  type_parameters(:U)
    .params(klass: T.class_of(A)[A, Integer])
    .void
end
def example0(klass)
  x = klass.foo
  T.reveal_type(x)
  a = klass.new
  T.reveal_type(a)
end

sig do
  type_parameters(:U)
    .params(klass: T.class_of(A)[Integer])
    .void
end
def example1(klass)
  x = klass.foo
  T.reveal_type(x)
  a = klass.new
  T.reveal_type(a)
end

sig do
  type_parameters(:U)
    .params(klass: T.class_of(A)[ChildA, Integer])
    .void
end
def example2(klass)
  x = klass.foo
  T.reveal_type(x)
  a = klass.new
  T.reveal_type(a)
end

example2(A)
example2(ChildA)

sig do
  type_parameters(:U)
    .params(klass: T.class_of(A)[T.all(A, T.type_parameter(:U)), Integer])
    .returns(T.all(A, T.type_parameter(:U)))
end
def example3(klass)
  x = klass.foo
  T.reveal_type(x)
  a = klass.new
  T.reveal_type(a)
  y = a.instance_method
  T.reveal_type(y)
  a
end

instance = example3(A)
T.reveal_type(instance)
instance = example3(ChildA)
T.reveal_type(instance)

