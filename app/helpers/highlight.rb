def highlight(text, phrases, options = {})

  if text.empty? || phrases.empty?
    text || ""
  else
    match = Array(phrases).map do |p|
      Regexp === p ? p.to_s : Regexp.escape(p)
    end.join('|')

    if block_given?
      text.gsub(/(#{match})(?![^<]*?>)/) { |found| yield found }
    else
      highlighter = options.fetch(:highlighter, '<mark>\1</mark>')
      text.gsub(/(#{match})(?![^<]*?>)/, highlighter)
    end
  end.html_safe
end