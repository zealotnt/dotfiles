#!/bin/ruby
# coding: utf-8
# https://gist.github.com/justin808/1fe1dfbecc00a18e7f2a
# Using these pry gems
# gem install "pry"
# gem install "pry-rails"
# gem install "pry-byebug"
# gem install "pry-stack_explorer"
# gem install "pry-doc"
# gem install "pry-state"
# gem install "pry-toys"
# gem install "pry-rescue"
# gem install "awesome_print"
# gem install "binding_of_caller"
# gem install "rb-readline"
# gem install "highline"
# gem install "gem-open"

# Fix for Zeus: see https://github.com/burke/zeus/issues/466#issuecomment-60242431
if defined?(::Rails) && Rails.env
  if Rails::VERSION::MAJOR == 3
    verbose, $VERBOSE = $VERBOSE, nil
    if defined?(Rails::Console)
      Rails::Console::IRB = ::Pry unless Rails::Console::IRB == ::Pry
    end
    $VERBOSE = verbose

    unless defined? ::Pry::ExtendCommandBundle
      ::Pry::ExtendCommandBundle = Module.new
    end
  end

  if defined?(Rails) && Rails::VERSION::MAJOR == 4 && Rails.application
    unless Rails.application.config.console == ::Pry
      Rails.application.config.console = ::Pry
    end
  end

  if ((Rails::VERSION::MAJOR == 3 && Rails::VERSION::MINOR >= 2) ||
      Rails::VERSION::MAJOR == 4)
    unless defined? ::Rails::ConsoleMethods
      require 'rails/console/app'
      require 'rails/console/helpers'

      TOPLEVEL_BINDING.eval('self').extend ::Rails::ConsoleMethods
    end
  end
end

# #### END FIX FOR ZEUS

Pry::Commands.block_command "noconflict", "Rename step to sstep and next to nnext" do
  Pry::Commands.rename_command("nnext", "next")
  Pry::Commands.rename_command("bbreak", "break")
end

Pry::Commands.block_command "unnoconflict", "Revert to normal next and break" do
  Pry::Commands.rename_command("next", "nnext")
  Pry::Commands.rename_command("break", "bbreak")
end

## Useful Collections

def a_array
  (1..6).to_a
end

def a_hash
  {hello: "world", free: "of charge"}
end

## Benchmarking
# Inspired by <http://stackoverflow.com/questions/123494/whats-your-favourite-irb-trick/123834#123834>.

def do_time(repetitions = 100, &block)
  require 'benchmark'
  Benchmark.bm{|b| b.report{repetitions.times(&block)}}
end


Pry.config.color = true

# http://rocket-science.ru/hacking/2018/10/27/pry-with-whistles
# === EDITOR ===
# Pry.config.editor = proc { |file, line| "emacsclient -nw -create-frame +#{line} #{file}" }
Pry.config.editor = proc { |file, line| "nvim +#{line} #{file}" }

# === PROMPT ===
Pry.config.prompt_name = ""

# === COLORS ===
unless ENV['PRY_BW']
  Pry.color = true
  Pry.config.theme = "railscasts"
  Pry.config.prompt = PryRails::RAILS_PROMPT if defined?(PryRails::RAILS_PROMPT)
  Pry.config.prompt ||= Pry.prompt
end

# === HISTORY ===
if Gem::Version.new("0.12.2") >= Gem::Version.new(Pry::VERSION)
  Pry.config.history.should_save = true
  Pry.config.history.should_load = true
  Pry.config.history.default_file = "~/.pry_history"
end

# Hit Enter to repeat last command
Pry::Commands.command /^$/, "repeat last command" do
  pry_instance.run_command Pry.history.to_a.last
end

Pry.config.commands.alias_command "h", "hist -T 20", desc: "Last 20 commands"
Pry.config.commands.alias_command "hg", "hist -T 20 -G", desc: "Up to 20 commands matching expression"
Pry.config.commands.alias_command "hG", "hist -G", desc: "Commands matching expression ever used"
Pry.config.commands.alias_command "hr", "hist -r", desc: "hist -r <command number> to run a command"

# === Listing config ===
# Better colors - by default the headings for methods are too
# similar to method name colors leading to a "soup"
# These colors are optimized for use with Solarized scheme
# for your terminal
Pry.config.ls.separator = "\n" # new lines between methods
Pry.config.ls.heading_color = :magenta
Pry.config.ls.public_method_color = :green
Pry.config.ls.protected_method_color = :yellow
Pry.config.ls.private_method_color = :bright_black

def help_pry_shortcut
  puts "Debugging Shortcuts"
  puts 'ss  :  step'
  puts 'nn  :  next'
  puts 'cc  :  continue'
  puts 'fin :  finish'
  puts 'uu  :  up'
  puts 'dd  :  down'
  puts 'bb  :  break'
  puts 'ww  :  whereami'
  puts 'ff  :  frame'
  puts 'sss :  show-stack'
  puts '$   :  show whole method of context'
  puts
  puts "Run 'pry_shortcut_debug' to display shorter debug shortcuts"
end

if defined?(PryByebug)
   def pry_shortcut_debug
     # Pry.commands.alias_command 't', 'show-stack'
     Pry.commands.alias_command '\s', 'step'
     Pry.commands.alias_command '\n', 'next'
     Pry.commands.alias_command '\c', 'continue'
     Pry.commands.alias_command '\u', 'up'
     Pry.commands.alias_command '\d', 'down'
     Pry.commands.alias_command '\b', 'break'
     Pry.commands.alias_command '\w', 'whereami'
     Pry.commands.alias_command ':q', 'exit-program'
     Pry.commands.alias_command 'quit', 'exit-program' # make it same with byebug
     Pry.commands.alias_command '\q', 'exit-program' # make it same with psql
     Pry.commands.alias_command 'exit', 'exit-program' # make it same with byebug

     help_pry_shortcut
   end

   # Longer shortcuts
   Pry.commands.alias_command 'ff', 'frame'

   # Pry.commands.alias_command 'sss', 'show-stack'
   Pry.commands.alias_command 'ss', 'step'
   Pry.commands.alias_command 'nn', 'next'
   Pry.commands.alias_command 'cc', 'continue'
   Pry.commands.alias_command 'fin', 'finish'
   Pry.commands.alias_command 'uu', 'up'
   Pry.commands.alias_command 'dd', 'down'
   Pry.commands.alias_command 'bb', 'break'
   Pry.commands.alias_command 'ww', 'whereami'
end

if defined?(::Rails) && Rails.env && Rails.env.test? && ENV["PRY_LONG"].blank?
  pry_shortcut_debug
end

if not ENV["PRY_SHORT"].nil? && ENV["PRY_SHORT"].true?
  pry_shortcut_debug
else
  begin
    require 'highline/import'
    confirm = ask("Enable pry-shortcut [y/n]? ") { |yn| yn.default = "y\n", yn.limit = 1, yn.validate = /[yn]/i }
    pry_shortcut_debug if confirm.downcase == 'y'
  rescue LoadError => err
    puts "gem install highline # <-- !!??"
    puts "type: pry_shortcut_debug to apply pry shortkeys"
  end
end

# == PLUGINS ===
# awesome_print gem: great syntax colorized printing
# look at ~/.aprc for more settings for awesome_print
begin
  require 'awesome_print'
  # The following line enables awesome_print for all pry output,
  # and it also enables paging
  Pry.config.print = proc {|output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}", output)}

  # If you want awesome_print without automatic pagination, use the line below
  module AwesomePrint
    Formatter.prepend(Module.new do
      def awesome_self(object, type)
        if type == :string && @options[:string_limit] && object.inspect.to_s.length > @options[:string_limit]
          colorize(object.inspect.to_s[0..@options[:string_limit]] + "...", type)
        else
          super(object, type)
        end
      end
    end)
  end

  AwesomePrint.defaults = {
    :string_limit => 140,
    :indent => 2,
    :multiline => true
  }
  AwesomePrint.pry!
rescue LoadError => err
  puts "gem install awesome_print  # <-- highly recommended"
end

my_hook = Pry::Hooks.new.add_hook(:before_session, :add_dirs_to_load_path) do
  # adds the directories /spec and /test directories to the path if they exist and not already included
  dir = `pwd`.chomp
  dirs_added = []
  %w(spec test presenters lib).map{ |d| "#{dir}/#{d}" }.each do |p|
    if File.exist?(p) && !$:.include?(p)
      $: << p
      dirs_added << p
    end
  end
  puts "Added #{ dirs_added.join(", ") } to load path in ~/.pryrc." if dirs_added.present?
end
# my_hook.exec_hook(:before_session)

Pry.config.hooks.add_hook(:after_session, :say_hi) do
  history_file = Pry.config.history_file
  if !history_file.nil? and File.file?(history_file)
    puts "Cleaning up history file #{history_file}"
    puts "\tBefore cleaning: #{`cat #{history_file} | wc -l`}"
    `sed --in-place 's/[[:space:]]\+$//' #{history_file}`
    `tac #{history_file} | awk '!x[$0]++' | tac | sponge #{history_file}`
    puts "\tAfter cleaning: #{`cat #{history_file} | wc -l`}"
  end
end
# my_hook.exec_hook(:after_session)

begin
  require 'rb-readline'
  require 'readline'
  if defined?(RbReadline)
    def RbReadline.rl_reverse_search_history(sign, key)
      # rl_insert_text  `cat -n ~/.pry_history | fzf --tac | tr -d '\n' | sed -r 's/\s+[0-9]+\s+//'`
      rl_insert_text  `cat ~/.pry_history | fzf --tac | tr -d '\n'`
    end
    Readline.basic_word_break_characters = " \t\n`><=.;|&{("
  end
rescue LoadError => err
  puts "gem install rb-readline readline  # <-- highly recommended"
end

puts "Loaded ~/.pryrc"
puts

def more_help
  puts "Helpful shortcuts:"
  puts "hh  : hist -T 20       Last 20 commands"
  puts "hg : hist -T 20 -G    Up to 20 commands matching expression"
  puts "hG : hist -G          Commands matching expression ever used"
  puts "hr : hist -r          hist -r <command number> to run a command"
  puts

  puts "Samples variables"
  puts "a_array  :  [1, 2, 3, 4, 5, 6]"
  puts "a_hash   :  { hello: \"world\", free: \"of charge\" }"
  puts
  puts "helper   : Access Rails helpers"
  puts "app      : Access url_helpers"
  puts
  puts "require \"rails_helper\"              : To include Factory Girl Syntax"
  puts "include FactoryGirl::Syntax::Methods  : To include Factory Girl Syntax"
  puts
  puts "or if you defined one..."
  puts "require \"pry_helper\""
  puts
  puts "Sidekiq::Queue.new.clear              : To clear sidekiq"
  puts "Sidekiq.redis { |r| puts r.flushall } : Another clear of sidekiq"
  puts
  puts "Debugging Shortcuts"
  puts 'ss  :  step'
  puts 'nn  :  next'
  puts 'cc  :  continue'
  puts 'fin :  finish'
  puts 'uu  :  up'
  puts 'dd  :  down'
  puts 'bb  :  break'
  puts 'ww  :  whereami'
  puts 'ff  :  frame'
  puts 'sss :  show-stack'
  puts '$   :  show whole method of context'
  puts
  puts "Run 'pry_shortcut_debug' to display shorter debug shortcuts"
  help_pry_shortcut
  ""
 end
puts "Run 'more_help' to see tips"

def refresh_gem
  Gem.clear_paths
end
