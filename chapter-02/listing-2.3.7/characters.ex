# Strings are not character lists
# To run:
# 1) iex characters.ex => enters Interactive Elixir
# 2) Characters.one
# 5) Press ctrl-c twice to exit Interactive Elixir
defmodule Characters do
  def one do
    'hi' == "hi" # => false
  end
end
