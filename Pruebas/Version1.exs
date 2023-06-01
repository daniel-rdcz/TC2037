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

cond do
  state == :start and is_punctuation?(char) -> {:punctuation, true}
  state == :start and is_object_key?(char) -> {:object_key, false}
  state == :start and is_double_dots?(char) -> {:double_dots, true}
  state == :start and is_corchete?(char) -> {:corchete, true}
  state == :punctuation and is_punctuation?(char) -> {:punctuation, true}
  state == :punctuation and is_double_dots?(char) -> {:double_dots, true}
  state == :double_dots and is_comillas?(char) -> {:string, false}
  state == :double_dots and is_double_dots?(char) -> {:double_dots, true}
  state == :double_dots and is_punctuation?(char) -> {:punctuation, true}
  state == :double_dots and is_comillas?(char) -> {:string, false}
  state == :object_key and is_object_key?(char) -> {:object_key, false}
  state == :object_key and is_punctuation?(char) -> {:punctuation, true}
  state == :object_key and is_double_dots?(char) -> {:double_dots, true}
  state == :string and is_string?(char) -> {:string, false}
  state == :string and is_punctuation?(char) -> {:string, false}
  state == :string and is_dot?(char) -> {:string, false}
  state == :string and is_double_dots?(char) -> {:string, false}
  state == :string and is_comillas?(char) -> {:close_str, false}
  state == :close_str and is_punctuation?(char) -> {:punctuation, true}
  state == :double_dots and is_number?(char) -> {:number, false}
  state == :double_dots and is_corchete?(char) -> {:corchete, true}
  state == :corchete and is_number?(char) -> {:number, false}
  state == :corchete and is_punctuation?(char) -> {:punctuation, true}
  state == :corchete and is_llave?(char) -> {:lista, true}
  state == :punctuation and is_number?(char) -> {:number, false}
  state == :number and is_punctuation?(char) -> {:punctuation, true}
  state == :number and
  state == :number and is_number?(char) -> {:number, false}
  state == :double_dots and is_llave?(char) -> {:lista, true}
  state == :lista and is_object_key?(char) -> {:object_key, false}
  state == :punctuation and is_object_key?(char) -> {:object_key, false}
  state == :number and is_dot?(char) -> {:number, false}
  state == :f2 and (char == "a") -> {:f3, false}
  state == :f3 and (char == "l") -> {:f4, false}
  state == :f4 and (char == "s") -> {:f5, false}
  state == :f5 and (char == "e") -> {:f6, false}
  state == :f6 and is_punctuation?(char) -> {:punctuation, true}
  state == :t2 and (char == "r") -> {:t3, false}
  state == :t3 and (char == "u") -> {:t4, false}
  state == :t4 and (char == "e") -> {:t5, false}
  state == :t5 and is_punctuation?(char) -> {:punctuation, true}
  state == :double_dots and (char == "f") -> {:f2, false}
  state == :double_dots and (char == "t") -> {:t2, false}
end
