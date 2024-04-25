Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
Rails.application.config.assets.precompile += %w( rich/base.js rich/editor.css  chat/ja_chat.min.js chat/script.js fontawesome.css chat/rc-realtime-api.js )
