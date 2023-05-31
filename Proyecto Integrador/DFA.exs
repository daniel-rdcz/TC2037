defmodule JSON_DFA do
  def readerWritter(in_filename, out_filename) do
    data =
      in_filename
      |> File.stream!()
      |> Enum.map(&evaluateLine/1)
      |> Enum.join("")
    File.write(out_filename, data)
  end

  def evaluateLine(line) do
    chars = String.graphemes(line)
    recursion_function(chars, [], [], :start)
    |> Enum.reverse() # Invertir la lista para obtener el orden correcto
    |> Enum.join("") # Unir los elementos en una cadena
  end

  defp recursion_function([], tokens, current_token, _state) do
    [Enum.join(current_token, "") | tokens]
  end
  defp recursion_function([" " | rest], tokens, _current_token, state) do
    recursion_function(rest, [" " | tokens], [], state)
  end
  defp recursion_function(["\n" | rest], tokens, _current_token, state) do
    recursion_function(rest, ["\n" | tokens], [], state)
  end
  defp recursion_function([head | tail], tokens, current_token, state) do
    {new_state, token_found} = stepper(state, head)
    if token_found do
      if Enum.empty?(current_token) do
        tokens = [classer(head, state) | tokens]
        recursion_function(tail, tokens, [], new_state)
      else
        tokens = [classer(Enum.reverse(current_token) |> Enum.join(""), state) | tokens]
        recursion_function([head | tail], tokens, [], new_state)
      end
    else recursion_function(tail, tokens, [head | current_token], new_state) end
  end

  def classer(token, state) do
    cond do
      state == :start and is_punctuation?(token) -> "<span class=\"punctuation\">#{token}</span>"
      state == :start and is_object_key?(token) -> "<span class=\"object-key\">#{token}</span>"
      state == :punctuation -> "<span class=\"punctuation\">#{token}</span>"
      state == :object_key -> "<span class=\"object-key\">#{token}</span>"
    end
  end

  def stepper(state, char) do #nombrs de funciones
    cond do
      state == :start and is_punctuation?(char) -> {:punctuation, true}
      state == :start and is_object_key?(char) -> {:object_key, false}
      state == :punctuation and is_punctuation?(char) -> {:punctuation, true}
      state == :punctuation and is_object_key?(char) -> {:object_key, false}
      state == :object_key and is_punctuation?(char) -> {:punctuation, true}
      state == :object_key and is_object_key?(char) -> {:object_key, false}
    end
  end

  def is_punctuation?(char) do
    punctuation_regex = ~r/[,.:;\[\]{}()]/
    Regex.match?(punctuation_regex, char)
  end
  def is_object_key?(char) do
    object_key_regex = ~r/["a-zA-Z0-9_\- ]/
    Regex.match?(object_key_regex, char)
  end
  def is_string?(char) do
    string_regex = ~r/["a-zA-Z0-9_\- ]/
    Regex.match?(string_regex, char)
  end
end
# JSON_DFA.readerWritter("example.json", "ex.html")
