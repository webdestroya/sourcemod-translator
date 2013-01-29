module UsersHelper

  def flair_counts(number)
    number
  end

  def flair_rep(number)
    if number > 99999
      "#{(number.to_f/1000.0).ceil}k"
    elsif number > 9999
      "#{(number.to_f/1000.0).round(1)}k"
    else
      number_with_delimiter number
    end
  end

  def flair_avatar(avatar)
    if avatar.blank?
      "no_avatar.jpg"
    else
      avatar
    end
  end

end
