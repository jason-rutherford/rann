guard :rspec, cmd: 'rspec --color' do
  watch(%r{^(.+)\.rb})          { |m| "spec/#{m[1]}_spec.rb" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end