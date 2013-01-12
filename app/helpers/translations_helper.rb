module TranslationsHelper

  def fancy_text(translation)
    text = translation.text
    if translation.phrase.format
      if translation.phrase.format_infos.count > 0
        translation.phrase.format_infos.each do |fmt|
          text.gsub!(/(\{#{fmt.position}\})/, "<strong rel=\"tooltip\" title=\"TEST\">\\1</strong>")
        end
      else
        
        text.gsub!(/(\%[dixfsct])/, "<strong>\\1</strong>")
      end
    end


    text = colorize_translation(text)

    content_tag(:span, text.html_safe, class: "phrase-text fancy-text")
  end

  def colorize_translation(text)
    text.gsub! /(?:{([a-z]+)})/, "</span><span class=\"color-\\1\">{\\1}"
    "<span class=\"colorized\"><span>#{text}</span></span>"
  end

end
