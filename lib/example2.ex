defmodule Example2 do
  import Poz
  
  def run do
    Progress.start_link([:select, :download, :extract, :index])

    select()
    |> Stream.concat([])
    |> Stream.map(&download/1)
    |> Stream.map(&extract/1)
    |> Enum.to_list()
    |> index()

    Progress.stop()
  end
end
