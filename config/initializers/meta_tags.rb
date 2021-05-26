# Use this setup block to configure all options available in MetaTags.
MetaTags.configure do |config|
  config.title_limit = 70
  config.truncate_site_title_first = false
  config.description_limit = 300
  config.keywords_limit = 255
  config.keywords_separator = ', '
  config.keywords_lowercase = true
  config.minify_output = false
  config.open_meta_tags = true
end
