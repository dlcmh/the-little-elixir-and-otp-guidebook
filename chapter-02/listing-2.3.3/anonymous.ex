# Defining anonymous functions
# To run:
# 1) iex anonymous.ex => enters Interactive Elixir
# 2) Anonymous.example1
# 3) Anonymous.example2
# 4) Press ctrl-c twice to exit Interactive Elixir
defmodule Anonymous do
  def example1, do: Enum.map([1, 2, 3], fn(x) -> x * 10 end)
  def example2, do: Enum.map([1, 2, 3], fn x -> x * x end)
end
