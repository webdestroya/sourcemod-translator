if defined?(Tire)
  Tire.configure do
    url ENV['ELASTICSEARCH_URL']
  end
end