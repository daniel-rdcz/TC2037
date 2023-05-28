defmodule FilesGenerator do
  def write_html_file(file_path, text) do
    html = """
    <!DOCTYPE html>
    <html>
    <head>
      <title>My HTML File</title>
    </head>
    <body>
      <h1>Hello, Elixir!</h1>
      <p>#{text}</p>
    </body>
    </html>
    """

    File.write(file_path, html)
  end

# The write_html_file function now takes an additional text parameter.
# Inside the HTML content, we use #{text} to interpolate the value of
# text into the <pre></pre> tags.

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
end

# Usage example:
FilesGenerator.write_css_file("token_colors.css")
FilesGenerator.write_html_file("myfile.html", "This is dynamically inserted text.")
