require File.expand_path('../boot', __FILE__)

Rails::Initializer.run do |config|
  config.load_paths += %W( #{Rails.root}/app/sweepers )

  config.active_record.observers = :message_observer, :issue_observer, :journal_observer, :news_observer, :document_observer, :wiki_content_observer
end
