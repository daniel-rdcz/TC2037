defmodule JSON_DFA do
  def readerWritter(in_filename, out_filename) do
    data =
      in_filename
      |> File.stream!()
      |> Enum.map(&main/1)
      |> Enum.join("")

    File.write(out_filename, data)
  end

  defstruct function: nil, initial_state: nil, accepted_states: []

  def main(line) do
    evaluateLine(
      %JSON_DFA{
        function: &deltaArithmetic/2,
        initial_state: :start,
        accepted_states: [:punctuation, :object_key]
      },
      line
    )
  end

  def evaluateLine(dfaToEvaluate, line) do
    chars = String.graphemes(line)
    letLoop(chars, dfaToEvaluate, [], [], dfaToEvaluate.initial_state)
  end

  defp letLoop(chars, dfa, tokens, current_token, state) do
    cond do
      Enum.empty?(chars) ->
        tokens ++ [Enum.join(current_token, "")]

      hd(chars) == " " or hd(chars) == "\n" ->
        letLoop(
          tl(chars),
          dfa,
          tokens ++ [hd(chars)],
          current_token,
          state
        )

      true ->
        {new_state, token_found} = dfa.function.(state, hd(chars))

        if token_found do
          if Enum.empty?(current_token) do
            current_token = current_token ++ [hd(chars)] #no usar append
            tokens = tokens ++ [classer(Enum.join(current_token, ""), state)]
            letLoop(
            tl(chars), #[head | tail]
            dfa,
            tokens,
            [],
            new_state
          )
          else
            tokens = tokens ++ [classer(Enum.join(current_token, ""), state)]
            letLoop(
            chars,
            dfa,
            tokens,
            [],
            new_state
          )
          end

        else
          letLoop(
            tl(chars),
            dfa,
            tokens,
            current_token ++ [hd(chars)],
            new_state
          )
        end

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
