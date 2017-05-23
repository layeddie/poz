defmodule Example4 do
  defmodule Select do
    use GenStage

    def init(_), do: {:producer, :ok}

    def handle_demand(demand, :ok) do
      IO.inspect {:SELECT, :demand, demand}
      items = Poz.select()
      {:noreply, items, :empty}
    end

    def handle_demand(_demand, :empty) do
      {:noreply, [], :empty}
    end
  end

  defmodule Download do
    use GenStage

    def init(_), do: {:producer_consumer, :ok}

    def handle_events(items, _from, state) do
      IO.inspect {:DOWNLOAD, length(items)}
      files = Enum.map(items, &Poz.download/1)
      {:noreply, files, state}
    end
  end

  defmodule Extract do
    use GenStage

    def init(_), do: {:producer_consumer, :ok}

    def handle_events(files, _from, state) do
      IO.inspect {:EXTRACT, length(files)}
      texts = Enum.map(files, &Poz.extract/1)
      {:noreply, files, texts}
    end
  end

  defmodule Index do
    use GenStage

    def init(_), do: {:consumer, :ok}

    def handle_events(texts, _from, state) do
      IO.inspect {:INDEX, length(texts)}
      Poz.index(texts)
      {:noreply, [], state}
    end
  end

  def run do
    Progress.start_link([:select, :download, :extract, :index])

    {:ok, select}   = GenStage.start_link(Select, :ok)
    {:ok, download} = GenStage.start_link(Download, :ok)
    {:ok, extract}  = GenStage.start_link(Extract, :ok)
    {:ok, index}    = GenStage.start_link(Index, :ok)

    GenStage.sync_subscribe(download, to: select)
    GenStage.sync_subscribe(extract, to: download)
    GenStage.sync_subscribe(index, to: extract)

    :timer.sleep(:infinity)

    Progress.stop()
  end
end
