module MarkdownHelper
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end

  def markdown_to_html(text)
    renderer = HTMLwithPygments.new(filter_html: true, hard_wrap: true)
    markdown = Redcarpet::Markdown.new(renderer,
                                       { fenced_code_blocks: true, autolink: true, tables: true })
    sanitize(markdown.render(text))
  end
end
