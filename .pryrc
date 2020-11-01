# frozen_string_literal: true

# Hit Enter to repeat last command
Pry::Commands.command /^$/, 'repeat last command' do
  _pry_.run_command Pry.history.to_a.last
end

# reloads the environment
# to read rails env => $ pry -r pry -r ./config/environment.rb
def reload!(print = true)
  puts 'Reloading...' if print
  # This triggers the to_prepare callbacks
  ActionDispatch::Callbacks.new(proc {}, false).call({})
  true
end

if defined?(PryByebug)
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'c', 'continue'
end
