module Kaminari
  module Helpers
    class Paginator < Tag
      def relevant_pages(options)
        1..options[:total_pages]
      end

      class PageProxy
        def inside_window?
          if @options[:current_page] <= @options[:window]
            @page <= (@options[:window] * 2) + 1
          elsif (@options[:total_pages] - @options[:current_page].number) < @options[:window]
            @page >= (@options[:total_pages] - (@options[:window] * 2))
          else
            (@options[:current_page] - @page).abs <= @options[:window]
          end
        end
      end
    end
  end
end
