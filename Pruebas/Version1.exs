defmodule FileReader do
  def read_text_file(file_path) do
    case File.read(file_path) do
      {:ok, binary} ->
        {:ok, String.trim(binary)}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
