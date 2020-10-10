# frozen_string_literal: true

class System
  class << self
    def remove_entry(arg)
      dirs = Array.wrap(arg)
      dirs.each do |dir|
        absolute_path = File.expand_path(dir.to_s)
        unless absolute_path.starts_with?('/Users/r.kornev/work/_/hub/data/feeds/')
          raise "Danger remove #{absolute_path}"
        end

        FileUtils.remove_entry(absolute_path, true)
      end
    end
  end
end
