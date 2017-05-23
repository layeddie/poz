defmodule Example3 do
  import Poz

  def run do
    Progress.start_link([:select, :download, :extract, :index])

    select()
    |> Enum.map(fn e -> Task.async(Poz, :download, [e]) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(fn e -> Task.async(Poz, :extract, [e]) end)
    |> Enum.map(&Task.await/1)
    |> index()

    Progress.stop()
  end
end
