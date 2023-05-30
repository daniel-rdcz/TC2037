defmodule JSON_DFA do
  def readerWritter(in_filename, out_filename) do
    data =
      in_filename
      |> File.stream!()
      |> Enum.map(&evaluateLine/1)
      |> Enum.join("")

    File.write(out_filename, data)
  end

  defstruct function: nil, initial_state: nil, accepted_states: []

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
    {new_state, token_found} = deltaArithmetic(state, head)
    if token_found do
      if Enum.empty?(current_token) do
        tokens = [classer(head, state) | tokens]
        recursion_function(tail, tokens, [], new_state)
      else
        tokens = [classer(Enum.reverse(current_token) |> Enum.join(""), state) | tokens]
        recursion_function([head | tail], tokens, [], new_state)
      end
    else
      recursion_function(tail, tokens, [head | current_token], new_state)
    end
  end

  def classer(token, state) do
    cond do
      state == :start ->
        cond do
          is_punctuation?(token) ->
            "<span class=\"punctuation\">#{token}</span>"

          is_object_key?(token) ->
            "<span class=\"object-key\">#{token}</span>"
#variable para clases
        end

      state == :punctuation ->
        "<span class=\"punctuation\">#{token}</span>"

      state == :object_key ->
        "<span class=\"object-key\">#{token}</span>"
    end
  end


  def deltaArithmetic(state, char) do #nombrs de funciones
    cond do
      state == :start ->
        cond do
          is_punctuation?(char) ->
            {:punctuation, true}

          is_object_key?(char) ->
            {:object_key, false}
        end

      state == :punctuation ->
        cond do
          is_punctuation?(char) ->
            {:punctuation, true}

          is_object_key?(char) ->
            {:object_key, false}
        end

      state == :object_key ->
        cond do
          is_object_key?(char) ->
            {:object_key, false}

          is_punctuation?(char) ->
            {:punctuation, true}
        end
    end
  end

  def is_punctuation?(char) do
    punctuations = [",", ".", ":", ";", "[", "]", "{", "}", "(", ")"]
    Enum.member?(punctuations, char)
  end

  def is_object_key?(char) do
    object_keys = [
      "\"", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
      "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
      "u", "v", "w", "x", "y", "z", "A", "B", "C", "D",
      "E", "F", "G", "H", "I", "J", "K", "L", "M", "N",
      "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
      "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7",
      "8", "9", "_", "-", " "
    ]
    Enum.member?(object_keys, char)
  end
end
# JSON_DFA.readerWritter("example.json", "ex.html")
