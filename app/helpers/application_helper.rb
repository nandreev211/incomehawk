module ApplicationHelper

  def avatar_url(user)
    if user.avatar_url.present?
      user.avatar_url
    else
      default_url = "#{root_url}images/guest.png"
      gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=48&d=#{CGI.escape(default_url)}"
    end
  end

  def p(price)
    opts = {:precision => 0}
    unless @organization.currency == 'USD'
      opts[:unit] = Organization.currency_symbol(@organization.currency)
    end

    number_to_currency(price, opts)
  end
  
  def p_description(payment)
    if payment.recurring == "Hourly"
      #remove trailing zeros from number of hours
      hours = sprintf "%g", payment.number_of_hours
      "(#{p(payment.rate)} * #{hours}) #{payment.description}"
    else
      "#{payment.description}" 
    end
  end
  
  def per(percents)
    "#{percents}%"
  end

  def percent(n, of)
    perc = of == 0 ? 0 : (n / of)*100
    perc.to_i
  end

  def percent_class(perc)
    per_class = (perc/10).to_i*10
    "per#{per_class}"
  end


  def d(date)
    # date.to_s(:short) if date
    l date if date
  end

  def dt(datetime)
    # datetime.strftime('%b %d, %Y %I:%M %p') if datetime
    l datetime if datetime
  end

  def active_tab(tab)
    tab == @current_tab ? "active" : ""
  end

end
