defmodule JSON do
  def writter(in_filename, out_filename) do
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
    |> Enum.reverse()
    |> Enum.join("")
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
  defp recursion_function(["\n" | rest], tokens, current_token, state) do
    tokens = [classer(Enum.reverse(current_token) |> Enum.join(""), state) | tokens]
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
      state == :start and is_corchete?(token) -> "<span class=\"punctuation\">#{token}</span>"
      state == :start and is_llave?(token) -> "<span class=\"punctuation\">#{token}</span>"
      state == :punctuation -> "<span class=\"punctuation\">#{token}</span>"
      state == :object_key -> "<span class=\"object-key\">#{token}</span>"
      state == :double_dots -> "<span class=\"punctuation\">#{token}</span>"
      state == :string -> "<span class=\"string\">#{token}</span>"
      state == :close_str -> "<span class=\"string\">#{token}</span>"
      state == :number -> "<span class=\"number\">#{token}</span>"
      state == :corchete -> "<span class=\"punctuation\">#{token}</span>"
      state == :lista -> "<span class=\"punctuation\">#{token}</span>"
      state == :f6 -> "<span class=\"reserved-word\">#{token}</span>"
      state == :t5 -> "<span class=\"reserved-word\">#{token}</span>"
      state == :corchete -> "<span class=\"punctuation\">#{token}</span>"
      state == :llave -> "<span class=\"punctuation\">#{token}</span>"
      state == :comma -> "<span class=\"punctuation\">#{token}</span>"
      state == :object_key_ok -> "<span class=\"object-key\">#{token}</span>"
      state == :double_dots_ok -> "<span class=\"punctuation\">#{token}</span>"
      state == :number_ok -> "<span class=\"number\">#{token}</span>"
      state == :comma_ok -> "<span class=\"punctuation\">#{token}</span>"
    end
  end

  def stepper(state, char) do
    cond do
      #estados start
      state == :start and char == "f" -> {:inv, false}
      state == :start and char == "t" -> {:inv, false}
      state == :start and is_comillas?(char)-> {:object_key, false}
      state == :start and is_corchete?(char)-> {:corchete, true}
      state == :start and is_llave?(char)-> {:llave, true}
      state == :start and is_punctuation?(char)-> {:punctuation, true}
      #estados corchete
      state == :corchete and is_comillas?(char)-> {:string, false}
      state == :corchete and is_number?(char)-> {:number, false}
      state == :corchete and char == "f" -> {:f2, false}
      state == :corchete and char == "t" -> {:t2, false}
      state == :corchete and is_corchete?(char)-> {:inv, true}
      state == :corchete and is_llave?(char)-> {:llave, true}
      state == :corchete and is_punctuation?(char)-> {:punctuation, true}
      #estados llave
      state == :llave and is_comillas?(char)-> {:comillas_ok, false}
      state == :llave and is_corchete?(char)-> {:corchete, true}
      #estados comillas
      state == :comillas and is_object_key?(char)-> {:object_key, false}
      state == :comillas and is_double_dots?(char)-> {:double_dots, true}
      state == :comillas_ok and is_object_key?(char)-> {:object_key_ok, false}
      #estados object_key
      state == :object_key and is_object_key?(char)-> {:object_key, false}
      state == :object_key and is_corchete?(char)-> {:inv, true}
      state == :object_key and is_llave?(char)-> {:inv, true}
      state == :object_key and is_number?(char)-> {:inv, false}
      state == :object_key and char == "f" -> {:inv_f, false}
      state == :object_key and char == "t" -> {:inv_t, false}
      state == :object_key and is_comillas?(char)-> {:object_key, true}
      state == :object_key and is_double_dots?(char)-> {:double_dots, true}
      state == :object_key and is_punctuation?(char)-> {:punctuation, true}
      state == :object_key_ok and is_object_key?(char)-> {:object_key_ok, false}
      state == :object_key_ok and is_comillas?(char)-> {:object_key_ok, true}
      state == :object_key_ok and is_double_dots?(char)-> {:double_dots_ok, true}
      #estados double_dots
      state == :double_dots and is_comillas?(char)-> {:string, false}
      state == :double_dots and is_corchete?(char)-> {:corchete, true}
      state == :double_dots and is_llave?(char)-> {:llave, true}
      state == :double_dots and is_number?(char)-> {:number, false}
      state == :double_dots and char == "f" -> {:f2, false}
      state == :double_dots and char == "t" -> {:t2, false}
      state == :double_dots_ok and is_number?(char)-> {:number_ok, false}
      #estados string
      state == :string and is_string?(char)-> {:string, false}
      state == :string and is_comillas?(char)-> {:close_str, false}
      state == :string and is_double_dots?(char)-> {:string, false}
      state == :string and is_comma?(char)-> {:string, false}
      state == :string and is_dot?(char)-> {:string, false}
      #estados close_str
      state == :close_str and is_punctuation?(char)-> {:punctuation, true}
      state == :close_str and is_comma?(char)->{:comma, true}
      #estados number
      state == :number and is_comillas?(char)-> {:inv, true}
      state == :number and is_corchete?(char)-> {:inv, true}
      state == :number and is_llave?(char)-> {:inv, true}
      state == :number and is_number?(char)-> {:number, false}
      state == :number and char == "f" -> {:inv_f, false}
      state == :number and char == "t" -> {:inv_t, false}
      state == :number and is_double_dots?(char)-> {:inv, true}
      state == :number and is_punctuation?(char)-> {:punctuation, true}
      state == :number and is_comma?(char)-> {:comma, true}
      state == :number and is_dot?(char)-> {:number, false}
      state == :number_ok and is_dot?(char)-> {:number_ok, false}
      state == :number_ok and is_number?(char)-> {:number_ok, false}
      state == :number_ok and is_comma?(char)-> {:comma_ok, true}
      state == :number_ok and is_punctuation?(char)-> {:punctuation, true}
      #estados boolean
      state == :f2 and (char == "a") -> {:f3, false}
      state == :f3 and (char == "l") -> {:f4, false}
      state == :f4 and (char == "s") -> {:f5, false}
      state == :f5 and (char == "e") -> {:f6, false}
      state == :t2 and (char == "r") -> {:t3, false}
      state == :t3 and (char == "u") -> {:t4, false}
      state == :t4 and (char == "e") -> {:t5, false}
      state == :f6 and is_punctuation?(char) -> {:punctuation, true}
      state == :f6 and is_comma?(char) -> {:comma, true}
      state == :t5 and is_punctuation?(char) -> {:punctuation, true}
      state == :t5 and is_comma?(char) -> {:comma, true}
      #estados punctuation
      state == :punctuation and is_punctuation?(char)-> {:punctuation, true}
      state == :punctuation and is_comillas?(char)-> {:string, false}
      state == :punctuation and is_corchete?(char)-> {:corchete, true}
      state == :punctuation and is_llave?(char)-> {:llave, true}
      state == :punctuation and is_comma?(char)-> {:comma, true}
      #estados comma
      state == :comma and is_comma?(char)-> {:comma, true}
      state == :comma and is_number?(char)-> {:number, false}
      state == :comma and is_comillas?(char)-> {:string, false}
      state == :comma_ok and is_comma?(char)-> {:comma_ok, true}
      state == :comma_ok and is_comillas?(char)-> {:object_key_ok, false}
    end
  end

  def is_dot?(char) do Regex.match?(~r/[.]/, char) end
  def is_corchete?(char) do Regex.match?(~r/[\[]/, char) end
  def is_llave?(char) do Regex.match?(~r/\{/, char)end
  def is_punctuation?(char) do Regex.match?(~r/[;\]\}()]/, char) end
  def is_comma?(char) do Regex.match?(~r/[,]/, char) end
  def is_double_dots?(char) do Regex.match?(~r/[:]/, char) end
  def is_comillas?(char) do Regex.match?(~r/["]/, char) end
  def is_object_key?(char) do Regex.match?(~r/[a-zA-Z0-9_+&#\/áéíóúÁÉÍÓÚ$%@&*~ñÑ]/u, char) end
  def is_string?(char) do Regex.match?(~r/[a-zA-Z0-9_+&#\/áéíóúÁÉÍÓÚ$%@&*~ñÑ;]/u, char) end
  def is_number?(char) do Regex.match?(~r/[0-9]+/, char) end

end

start_time_static = :os.system_time(:millisecond)

JSON.writter("../JSON/Files/base-file1.json", "static_highlight1.html")
JSON.writter("../JSON/Files/base-file2.json", "static_highlight2.html")
JSON.writter("../JSON/Files/base-file3.json", "static_highlight3.html")

end_time_static = :os.system_time(:millisecond)
execution_time_static = end_time_static - start_time_static

IO.puts("Tiempo de ejecucion estatica: #{execution_time_static} milisegundos")


start_time_parallel = :os.system_time(:millisecond)

{:ok, files} = File.ls("../JSON/Files")
files
  |> Enum.map(&Task.async(fn -> JSON.writter("../JSON/Files/#{&1}", "#{&1}.html") end))
  |> Enum.map(&Task.await(&1))

end_time_parallel = :os.system_time(:millisecond)
execution_time_parallel = end_time_parallel - start_time_parallel

IO.puts("Tiempo de ejecucion paralelo: #{execution_time_parallel} milisegundos")

IO.puts("Speedup: #{execution_time_static / execution_time_parallel}")
