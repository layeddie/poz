defmodule Example7 do
  import Poz

  def run do
    Progress.start_link([:select, :download, :extract, :index])

    select()
    |> Flow.from_enumerable(max_demand: 20)
    |> Flow.partition(max_demand: 20, stages: 5)
    |> Flow.map(&download/1)
    |> Flow.partition(max_demand: 20, stages: 2)
    |> Flow.map(&extract/1)
    |> Flow.partition(window: Flow.Window.count(50), stages: 1)
    |> Flow.reduce(fn -> [] end, fn item, list -> [item | list] end)
    |> Flow.emit(:state)
    |> Flow.partition(stages: 1)
    |> Flow.map(&index/1)
    |> Flow.run

    Progress.stop()
  end
end
