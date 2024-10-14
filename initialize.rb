# frozen_string_literal: true

# Load all entities
Dir.glob(['entities/*.rb', 'helpers/*.rb']).each do |file_path|
  File.basename(file_path, '.rb')
  require_relative file_path
end
