require 'open-uri'
require 'base64'
require 'digest/sha1'
require 'aws/s3'

require 'RMagick' unless defined?(Magick)

# Apply a few RMagick patches
require 'fleximage/rmagick_image_patch'

# Load dsl_accessor from lib
require 'dsl_accessor'

# Load Operators
require 'fleximage/operator/base'
Dir.entries("#{File.dirname(__FILE__)}/fleximage/operator").each do |filename|
  require "fleximage/operator/#{filename.gsub('.rb', '')}" if filename =~ /\.rb$/
end

# Setup Model
require 'fleximage/model'
ActiveRecord::Base.class_eval { include Fleximage::Model }

# Image Proxy
require 'fleximage/image_proxy'

# Setup View
#ActionController::Base.exempt_from_layout :flexi
if defined?(ActionView::Template)
  # Rails >= 2.1
  if Rails.version.to_f >= 3 
    require 'fleximage/rails3_view'
    ActionView::Template.register_template_handler :flexi, ActionView::TemplateHandlers::Rails3View
  else
    require 'fleximage/view'
    ActionView::Template.register_template_handler :flexi, Fleximage::View
  end
else
  # Rails < 2.1
  require 'fleximage/legacy_view'
  ActionView::Base.register_template_handler :flexi, Fleximage::LegacyView
end

# Setup Helper
require 'fleximage/helper'
ActionView::Base.class_eval { include Fleximage::Helper }

# Setup Aviary Controller
require 'fleximage/aviary_controller'
ActionController::Base.class_eval{ include Fleximage::AviaryController }

# Register mime types
Mime::Type.register_alias "image/pjpeg", :jpg # IE6 sends jpg data as "image/pjpeg".  Silly IE6.
Mime::Type.register "image/gif", :gif
Mime::Type.register "image/png", :png
