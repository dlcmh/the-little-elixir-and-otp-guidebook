# To run:
# 1) iex length_converter.ex => enters Interactive Elixir
# 2) MeterToLengthConverter.Feet.convert(2.72)
# 3) MeterToLengthConverter.Inch.convert(2.72)
# 4) Press ctrl-c twice to exit Interactive Elixir
defmodule MeterToLengthConverter.Feet do
  def convert(m) do
    m * 3.28084
  end
end

defmodule MeterToLengthConverter.Inch do
  def convert(m) do
    m * 39.3701
  end
end
