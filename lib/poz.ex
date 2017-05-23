defmodule Poz do
  def select do
    items = Enum.to_list (1..100)
    :timer.sleep(:rand.uniform(100))
    Progress.incr(:select, length(items))
    items
  end
  
  def download(index) do
    :timer.sleep(:rand.uniform(100))
    Progress.incr(:download)
    {:file, index}
  end

  def extract({:file, file}) do
    :timer.sleep(:rand.uniform(10))
    Progress.incr(:extract)
    {:text, file}
  end

  def index(texts) do
    :timer.sleep(:rand.uniform(1000))
    Progress.incr(:index, length(texts))
    :ok
  end
end
