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
        chars = tokens
        Enum.join(chars, "")

      not(Enum.empty?(chars)) ->
        {new_state, token_found} = dfa.function.(state, hd(chars))

        if token_found do
          tokens = tokens ++ [Enum.join(current_token, "")]
          current_token = []
        end
        if not(token_found) do
          current_token = current_token ++ [hd(chars)]
        end

        letLoop(tl(chars), dfa, tokens, current_token, new_state)
    end
  end

  def classer(token, state) do
    cond do
      state == :punctuation ->
        "<span class=\"punctuation\">" <> token <> "</span>"
    end
  end

  def deltaArithmetic(state, char) do
    cond do
      state == :start and char == "{" ->
        {:punctuation, false}

      state == :punctuation and char == "}" ->
        {:punctuation, true}
    end
  end
end

# JSON_DFA.readerWritter("example.json", "ex.html")
# tokens = ["p", "a", "s", "s", "e", "d"]
# chars =  tokens
# Enum.join(chars, "")
