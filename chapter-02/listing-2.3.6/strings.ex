# Strings are binaries
# To run:
# 1) iex strings.ex => enters Interactive Elixir
# 2) Strings.one
# 3) Strings.two
# 4) Strings.three
# 5) Press ctrl-c twice to exit Interactive Elixir
defmodule Strings do
  def one do
    "Strings are binaries" |> is_binary # => true
  end

  def two do
    # <> is a binary concatenation operator
    # <<0>> is a null byte
    "Big:" <> <<0>> # => <<66, 105, 103, 58, 0>>
  end

  def three do
    # <> is a binary concatenation operator
    # <<0>> is a null byte
    "Big:大" <> <<0>> # => <<66, 105, 103, 58, 229, 164, 167, 0>>
  end

  def four do
    ?a # => 97
  end

  def five do
    ?大 # => 22823
  end

  def six do
    IO.puts <<66, 105, 103, 58, 229, 164, 167>>
    # =>
    # Big:大
    # :ok
  end
end
