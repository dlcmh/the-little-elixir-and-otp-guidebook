# To run:
# 1) iex length_converter.ex => enters Interactive Elixir
# 2) MeterToFootConverter.convert(2.72)
# 3) Press ctrl-c twice to exit Interactive Elixir
defmodule MeterToFootConverter do
  def convert(m) do
    m * 3.28084
  end
end
