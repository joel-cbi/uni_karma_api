# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

require 'action_view'
include ActionView::Helpers::NumberHelper
number_with_delimiter 3.1

run Rails.application
