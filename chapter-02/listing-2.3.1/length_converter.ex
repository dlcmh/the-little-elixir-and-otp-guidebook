# Using function clauses
# To run:
# 1) iex length_converter.ex => enters Interactive Elixir
# 2) MeterToLengthConverter.convert(:feet, 2.72)
# 3) MeterToLengthConverter.convert(:inch, 2.72)
# 4) Press ctrl-c twice to exit Interactive Elixir
defmodule MeterToLengthConverter do
  def convert(:feet, m) do
    m * 3.28084
  end

  def convert(:inch, m) do
    m * 39.3701
  end
end
