defmodule Example1 do
  import Poz

  def run do
    Progress.start_link([:select, :download, :extract, :index])

    select()
    |> Enum.map(&download/1)
    |> Enum.map(&extract/1)
    |> index()

    Progress.stop()
  end
end
