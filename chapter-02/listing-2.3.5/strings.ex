# Strings - uppercase, reverse
# To run:
# 1) iex strings.ex => enters Interactive Elixir
# 2) Strings.operations
# 3) Press ctrl-c twice to exit Interactive Elixir
defmodule Strings do
  def operations do
    "Strings are #{:great}!" |> String.upcase |> String.reverse
  end
end
