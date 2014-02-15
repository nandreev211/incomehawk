raw_config = File.read("#{Rails.root}/config/app_config.yml")
APP_CONFIG = YAML.load(raw_config)[Rails.env].symbolize_keys

Paymill.api_key = "883fb915fcd1f9f089a50caad62c9278"
module IncomeHawk
  class ApiAuthenticationError < Exception
  end

  class ParametersError < Exception
  end
end
