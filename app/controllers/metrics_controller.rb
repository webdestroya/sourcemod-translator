class MetricsController < ApplicationController

  def index
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

    response = {
      timestamp: timestamp,
      metric_count: metrics.size,
      metrics: metrics,
    }

    render :json => response, callback: params[:callback]
  end

  private 

  def format_time(ts)
    # ts.strftime "%Y-%m-%d %H:00"
    ts.strftime "%Y-%m-%d"
  end

  def provider_name(provider)
    return "AlliedModders" if provider.eql?("allied_modders")
    return "Steam" if provider.eql?("steam")
    "Other"
  end

end
