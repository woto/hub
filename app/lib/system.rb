# frozen_string_literal: true

class System
  class << self
    def remove_entry(arg)
      dirs = Array.wrap(arg)
      dirs.each do |dir|
        absolute_path = File.expand_path(dir.to_s)
        FileUtils.remove_entry(absolute_path, true)
      end
    end
  end
end
