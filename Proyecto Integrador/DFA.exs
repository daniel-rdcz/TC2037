defmodule JSON_DFA do

  def readerWritter(in_filename, out_filename) do
    # Generar los nuevos datos cifrados
    data = in_filename
           |> File.stream!()
           |> Enum.map(&main(&1))
           |> Enum.join("")

    # Almacenar la cadena en el archivo
    File.write(out_filename, data)
  end

  defstruct function: nil, initial_state: nil, accepted_states: []

  def main(line) do
    evaluateLine(%JSON_DFA{function: &deltaArithmetic/2, initial_state: :start, accepted_states: :punctuation}, line)
  end

  def evaluateLine(dfaToEvaluate, line) do
    chars = String.graphemes(line)
    letLoop(chars, dfaToEvaluate, [], [], dfaToEvaluate.initial_state)
  end

  defp letLoop(chars, dfa, tokens, current_token, state) do
    cond do
      Enum.empty?(chars) ->
        tokens ++ [Enum.join(current_token, "")]

      true ->
        {new_state, token_found} = dfa.function.(state, hd(chars))

        if token_found do
          current_token = current_token ++ [hd(chars)]
          tokens = tokens ++ [classer(Enum.join(current_token, ""), state)]
          letLoop(
            tl(chars),
            dfa,
            tokens,
            [],
            new_state
          )
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
      state == :start and token == "{" or token == "}"->
        "<span class=\"punctuation\">#{token}</span>"

      state == :punctuation ->
        "<span class=\"punctuation\">#{token}</span>"
    end
  end

  def deltaArithmetic(state, char) do
    cond do
      state == :start and is_punctuation?(char)->
        {:punctuation, true}

      state == :punctuation and is_punctuation?(char)->
        {:punctuation, true}
    end
  end

  def is_punctuation?(char) do
    punctuations = ["!", "\"", "#", "$", "%", "&", "'", "(", ")", "*", "+", ",", "-", ".", "/", ":", ";", "<", "=", ">", "?", "@", "[", "\\", "]", "^", "_", "`", "{", "|", "}", "~"]
    Enum.member?(punctuations, char)
  end

end

# JSON_DFA.readerWritter("example.json", "ex.html")
# tokens = ["p", "a", "s", "s", "e", "d"]
# chars =  tokens
# Enum.join(chars, "")
