defmodule JSON_DFA do
  def readerWritter(in_filename, out_filename) do
    data =
      in_filename
      |> File.stream!()
      |> Enum.map(&evaluateLine/1)
      |> Enum.join("")

    write_html_file(out_filename, data)
    write_css_file("token_colors.css")
  end

  def write_html_file(file_path, text) do
    html = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>Resaltador de Sintaxis</title>
      <link rel="stylesheet" href="token_colors.css">
    </head>
    <body>
      <h1>Date: 2023-05-30</h1>
      <p> Created By Daniel Rodriguez, David Vieyra and Miguel Cabrera </p>
      <pre>#{text}</pre>
    </body>
    </html>
    """
    File.write(file_path, html)
  end

  def write_css_file(file_path) do
    css = """
    body {
      background-color: Black;
      color: Gray;
    }
     pre {
      font-family: Monospace;
      font-size: 20px;
    }
     h1 {
      color: Black;
      border: 4px solid red;
      background-color: Aquamarine;
      text-align: center;
    }
     .number {
      color: Lime;
    }
     .string {
      color: Yellow;
      font-style: italic;
    }
     .object-key {
      color: LightSkyBlue;
      font-weight: bold;
    }
     .reserved-word {
      font-weight: bold;
      color: SandyBrown;
    }
    .punctuation {
      color: LightGray;
    }
    """
    File.write(file_path, css)
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
  defp recursion_function([" " | rest], tokens, current_token, state) do
    if state == :string do
      recursion_function(rest, tokens, [" " | current_token], state)
    else
      recursion_function(rest, [" " | tokens], [], state)
    end
  end

  defp recursion_function(["\n" | rest], tokens, _current_token, state) do
    recursion_function(rest, ["\n" | tokens], [], state)
  end
  defp recursion_function([head | tail], tokens, current_token, state) do
    {new_state, token_found} = stepper(state, head)
    IO.puts(new_state)
    IO.puts(tokens)
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
      state == :punctuation_str -> "<span class=\"punctuation\">#{token}</span>"
      state == :string -> "<span class=\"string\">#{token}</span>"
      state == :close_str -> "<span class=\"string\">#{token}</span>"
    end
  end

  def stepper(state, char) do
    cond do
      state == :start and is_punctuation?(char) -> {:punctuation, true}
      state == :start and is_object_key?(char) -> {:object_key, false}
      state == :start and is_punctuation_str?(char) -> {:punctuation_str, true}
      state == :punctuation and is_punctuation?(char) -> {:punctuation, true}
      state == :punctuation and is_object_key?(char) -> {:object_key, false}
      state == :punctuation and is_punctuation_str?(char) -> {:punctuation_str, true}
      state == :punctuation_str and is_string?(char) -> {:string, false}
      state == :punctuation_str and is_comillas?(char) -> {:string, false}
      state == :punctuation_str and is_punctuation_str?(char) -> {:punctuation_str, true}
      state == :punctuation_str and is_punctuation?(char) -> {:punctuation, true}
      state == :object_key and is_object_key?(char) -> {:object_key, false}
      state == :object_key and is_punctuation?(char) -> {:punctuation, true}
      state == :object_key and is_punctuation_str?(char) -> {:punctuation_str, true}
      state == :string and is_string?(char) -> {:string, false}
      state == :string and is_punctuation?(char) -> {:string, false}
      state == :string and is_punctuation_str?(char) -> {:string, false}
      state == :string and is_comillas?(char) -> {:close_str, false}
      state == :close_str and is_punctuation?(char) -> {:punctuation, true}
    end
  end

  def is_punctuation?(char) do
    pattern = ~r/[[:punct:]]/ # Expresión regular que coincide con las puntuaciones ~r/[,.:;[\]{}()]/
    Regex.match?(pattern, char)
  end

  def is_object_key?(char) do
    pattern = ~r/^[a-zA-Z0-9_\- ]$/  # Expresión regular que coincide con los caracteres permitidos para una clave de objeto
    Regex.match?(pattern, char)
  end

  # def is_object_key?(char) do
  #   object_key_regex = ~r/["a-zA-Z0-9_\- ]/
  #   Regex.match?(object_key_regex, char)
  # end

  def is_punctuation_str?(char) do #quitar esto
    punctuation_str_regex = ~r/[:]/
    Regex.match?(punctuation_str_regex, char)
  end
  def is_comillas?(char) do
    str_cierre_regex = ~r/["]/
    Regex.match?(str_cierre_regex, char)
  end

  def is_string?(char) do
    string_regex = ~r/[a-zA-Z0-9_\-+&#\/]/
    Regex.match?(string_regex, char)
  end

end
JSON_DFA.readerWritter("example.json", "ex.html")
