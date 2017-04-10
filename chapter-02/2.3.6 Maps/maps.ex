# Maps
# To run:
# 1) iex characters.ex => enters Interactive Elixir
# 2) Maps.one
# 3) Press ctrl-c twice to exit Interactive Elixir
defmodule Maps do
  # Maps are immutable, hence the result of any mutation needs to be bound
  # to a new variable, or rebound to the original variable
  def one do
    programmers = Map.new
    IO.inspect(programmers) # => %{}

    programmers = Map.put(programmers, :joe, "Erlang")
    IO.inspect(programmers) # => %{joe: "Erlang"}

    programmers = Map.put(programmers, :matz, "Ruby")
    IO.inspect(programmers) # => %{joe: "Erlang", matz: "Ruby"}
  end
end
