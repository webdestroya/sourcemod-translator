module TranslationsHelper

  def fancy_text(translation)
    text = translation.text

    if translation.phrase.format
      if translation.phrase.format_infos.count > 0
        translation.phrase.format_infos.each do |fmt|
          text = text.gsub(/(\{(#{fmt.position})\})/, "<em rel=\"tooltip\" title=\"#{fmt.type}\">{\\2:#{fmt.format_class}}</em>")
        end
      end
    end

    text = text.gsub(/(\%[dixfsctN])/, "<em>\\1</em>")
    text = text.gsub(/(\%\.?[0-9]+[fd])/, "<em>\\1</em>")


    text = colorize_translation(text)

    content_tag(:span, text.html_safe, class: "phrase-text fancy-text")
  end

  def colorize_translation(text)
    text = text.gsub /(?:{([a-z]+)})/, "</span><span class=\"color-\\1\" title=\"{\\1}\">"
    "<span class=\"colorized\"><span>#{text}</span></span>"
  end

end
