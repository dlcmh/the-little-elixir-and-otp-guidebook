# Defining single-lined functions
# To run:
# 1) iex length_converter.ex => enters Interactive Elixir
# 2) MeterToLengthConverter.convert(:feet, 2.72)
# 3) MeterToLengthConverter.convert(:inch, 2.72)
# 4) MeterToLengthConverter.convert(:yard, 2.72)
# 5) Press ctrl-c twice to exit Interactive Elixir
defmodule MeterToLengthConverter do
  def convert(:feet, m), do: m * 3.28084
  def convert(:inch, m), do: m * 39.3701
  def convert(:yard, m), do: m * 1.09361
end
