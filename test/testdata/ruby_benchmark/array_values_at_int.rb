# frozen_string_literal: true
# typed: strict
# compiled: true
ary = Array.new(10000) {|i| i}
100000.times { ary.values_at(500) }