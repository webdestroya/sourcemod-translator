class MetricsController < ApplicationController

  def index
  end

  def translations

    metrics = {}
    resp = {
      metrics: []
    }

    readkey("translations").each do |point|
      time = format_time point.ts
      metrics[time] = {t: point.value}
    end

    readkey("translations_web").each do |point|
      metrics[format_time(point.ts)].merge!({w: point.value})
    end

    # readkey("translations_imported").each do |point|
    #   metrics[format_time(point.ts)].merge!({i: point.value})
    # end

    metrics.each_pair do |k,v|
      resp[:metrics] << v.merge({d: k})
    end

    render :json => resp
  end


  def plugins
    resp = {
      metrics: []
    }
    readkey("plugins").each do |point|
      resp[:metrics] << {
        d: format_time(point.ts),
        p: point.value
      }
    end
    render :json => resp
  end

  def users
    resp = {
      metrics: [],
      providers: []
    }
    readkey("users").each do |point|
      resp[:metrics] << {
        d: format_time(point.ts),
        u: point.value
      }
    end

    User.group(:provider).count.each do |provider,num|
      resp[:providers] << {label: provider_name(provider), value: num}
    end 

    render :json => resp
  end


  # This should be called in order to log the metrics to tempodb
  # ?nosave=1 to not save to tempodb
  # TODO: Maybe some cheesy authentication? param checking?
  def update

    metrics = []

    timestamp = Time.now.utc

    # Translations
    metrics << {key: "translations", v: Translation.count}
    metrics << {key: "translations_web", v: Translation.web.count}
    metrics << {key: "translations_imported", v: Translation.imported.count}
    
    # Phrases
    metrics << {key: "phrases", v: Phrase.count}

    # Users
    metrics << {key: "users", v: User.count}
    User.group(:provider).count.each do |provider,num|
      metrics << {key: "users_provider_#{provider}", v: num}
    end 
    # TODO: num users with web translations
    # TODO: num users with plugins
    
    # Plugins
    metrics << {key: "plugins", v: SourcemodPlugin.count}
    # TODO: plugins with 100% attempted
    # TODO: Plugins 100% completed

    # Avg: Langs per plugin
    # Avg: translations per plugin
    # Avg: phrases per plugin

    # Tags
    metrics << {key: "tags", v: Tag.count}
    metrics << {key: "tags_used", v: Tag.used.count}
    metrics << {key: "tags_unused", v: Tag.unused.count}

    tempodb.write_bulk timestamp, metrics unless params[:nosave].eql?("1")

    response = {
      timestamp: timestamp,
      metric_count: metrics.size,
      nosave: params[:nosave].eql?("1"),
      metrics: metrics,
    }

    render :json => response, callback: params[:callback]
  end

  private 

  def readkey(key)
    tempodb.read_key(key, 1.year.ago, Time.now.utc, :interval => "1day").data
  end

  def format_time(ts)
    # ts.strftime "%Y-%m-%d %H:00"
    ts.strftime "%Y-%m-%d"
  end

  def tempodb
    @tempodb ||= TempoDB::Client.new(ENV['TEMPODB_API_KEY'], ENV['TEMPODB_API_SECRET'])
  end

  def provider_name(provider)
    return "AlliedModders" if provider.eql?("allied_modders")
    return "Steam" if provider.eql?("steam")
    "Other"
  end

end
