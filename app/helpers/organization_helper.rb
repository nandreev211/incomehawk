module OrganizationHelper
  # Calculated percent for bar from 5 monthss
  def monthly_percent(month)
    return if !@last_5_months_totals || !@five_months_total
    monthly = @last_5_months_totals[month]
    percentage = if monthly == 0
        0
      else
        (monthly / @five_months_total)*100
      end
    per_class = (percentage/10).to_i*10
    "per#{per_class}"
  end

  def currency
    raw @organization.currency_symbol
  end
end
