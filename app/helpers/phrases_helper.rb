module PhrasesHelper

  def phrase_text(text)
    #text.html_safe
    text.gsub!(/(\{[0-9]+\})/, "<strong>\\1</strong>")
    text.gsub!(/(\%[dixfsct])/, "<strong>\\1</strong>")
    content_tag(:span, text.html_safe, class: "phrase-text")
  end

end
