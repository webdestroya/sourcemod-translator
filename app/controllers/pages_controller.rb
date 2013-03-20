class PagesController < ApplicationController

  def index

  end

  def home
  end

  # Statistics
  def stats

  end

  def contact
  end

  def changelog
  end

  # This should be called in order to log the metrics to tempodb
  def metrics_update

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
    
    # Plugins
    metrics << {key: "plugins", v: SourcemodPlugin.count}

    # Tags
    metrics << {key: "tags", v: Tag.count}
    metrics << {key: "tags_used", v: Tag.used.count}
    metrics << {key: "tags_unused", v: Tag.unused.count}

    blah = tempodb.write_bulk timestamp, metrics

    response = {
      timestamp: timestamp,
      metric_count: metrics.size,
      metrics: metrics,
      tempodb: blah
    }

    render :json => response, callback: params[:callback]
  end

end
