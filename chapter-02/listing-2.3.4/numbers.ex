# Numbers
# To run:
# 1) iex numbers.ex => enters Interactive Elixir
# 2) Numbers.integer_hexadecimal_float
# 3) Numbers.division
# 4) Numbers.remainder
# 5) Press ctrl-c twice to exit Interactive Elixir
defmodule Numbers do
  def integer_hexadecimal_float, do: 1 + 0x2F / 3.0
  def division, do: div(10, 3)
  def remainder, do: rem(10, 3)
end
