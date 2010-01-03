# ---- requirements
require 'rubygems'
require 'spec'

#strip_tags
require 'action_pack'
require 'action_controller'

$LOAD_PATH << File.expand_path("../lib", File.dirname(__FILE__))


# ---- setup environment/plugin
require 'active_record'
require File.expand_path("../init", File.dirname(__FILE__))
load File.expand_path("setup_test_model.rb", File.dirname(__FILE__))