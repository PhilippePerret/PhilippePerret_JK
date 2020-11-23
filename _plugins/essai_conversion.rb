# encoding: UTF-8
# frozen_string_literal: true
=begin
  Ce module pour essayer les conversions
=end
module Jekyll
  class FormatageConverter < Converter
      safe true
      priority :highest

      def matches(ext)
        ext =~ /^\.(md|markdown)$/i
      end

      def output_ext(ext)
        ext
      end

      def convert(content)
        # Les balises FILM, MOT, etc.
        content
          .gsub(/FILM\[([0-9]+)\|(.*?)\]/, '<a href="https://www.scenariopole.fr/filmodico/film/\1" target="_blank">\2</a>')
          .gsub(/MOT\[([0-9]+)\|(.*?)\]/, '<a href="https://www.scenariopole.fr/scenodico/mot/\1" target="_blank">\2</a>')
      end
    end
end
