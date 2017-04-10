# Guards
# To run:
# 1) iex characters.ex => enters Interactive Elixir
# 2) Guards.one(:any, "test")
# =>
# ** (FunctionClauseError) no function clause matching in Guards.one/2
#     guards.ex:7: Guards.one(:any, "test")
# 3) Press ctrl-c twice to exit Interactive Elixir
defmodule Guards do
  def one(:any, x) when is_number(x) and x >= 0 do
    IO.puts "#{x} is a valid positive number"
  end
end
