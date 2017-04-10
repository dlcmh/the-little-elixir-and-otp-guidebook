# Tuples
# To run:
# 1) iex characters.ex => enters Interactive Elixir
# 2) Tuples.one
# 3) Tuples.two
# 4) Press ctrl-c twice to exit Interactive Elixir
defmodule Tuples do
  def one do
    {200, "http://www.briefnotes.net"}
  end

  def two do
    elem({404, "http://www.dpnotes.com"}, 1) # => "http://www.dpnotes.com"
  end

  def three do
    put_elem({404, "http://www.dpnotes.com"}, 0, 200) # => {200, "http://www.dpnotes.com"}
  end
end
