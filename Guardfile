# frozen_string_literal: true

guard :rspec, cmd: 'bundle exec rspec' do
  # Run specs when a fabricator changes
  watch(%r{spec/factories/(.+).rb}) { 'spec' }

  # Run a spec when/if it changes
  watch(%r{^spec/.+_spec\.rb$})

  # Run spec again if spec_helper changes
  watch('spec/spec_helper.rb') { 'spec' }

  # If app/X changes, run spec/X
  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }

  # Run all the controllers if application_controller changes
  watch('app/controllers/application_controller.rb') { 'spec/controllers' }

  # If we have routing specs, run them when routes change:
  # watch('config/routes.rb')                           { "spec/routing" }
  # watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
end
