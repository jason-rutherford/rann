guard :rspec, cmd: 'rspec --color' do
  watch(%r{^(.+)\.rb})          { |m| "spec/#{m[1]}_spec.rb" }

  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

end

# when you are actively developing, this will execute the file
guard :shell do
  watch(%r{.+\.rb})do |m|
    # puts "*" * 40
    # puts "running #{m[0]}..."
    # puts `ruby #{m[0]}`
  end
end

guard :rubocop, all_on_start: false do
  # watch(%r{.+\.rb$})
  watch(%r{.+\.rb$}) { |m| m[0] }
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end
