# encoding: UTF-8
# frozen_string_literal: true
module Jekyll

  require_relative '../xdev/lib/required'


  module TagsFacilitatorModule
    def get_id_and_content_from_input(key_content = nil)
      dstr = @input.split(' ')
      id = dstr.shift
      content = dstr.join(' ')
      if key_content.nil?
        [id, content]
      else
        {id: id, key_content => content}
      end
    end
  end

  # Pour les films
  # Balise '{% film <id> <titre> %}'
  #
  class DateTags < Liquid::Tag
    def initialize(tag_name, str, token)
      super
      @input = str.strip
    end
    def render(context)
      time = nil
      hdate = if @input == ''
                time_to_hdate(Time.now)
              elsif @input.match?(REG_DATE)
                time_to_hdate(Time.new(*@input.split('/')))
              else
                @input.freeze
              end
      DATE_TAG % [hdate]
    end

    def time_to_hdate(time)
      formate_date(time)
    end

    DATE_TAG = '<span class="date">%s</span>'
    REG_DATE = %r![0-9]{4,4}/[0-9][0-9]/[0-9][0-9]!
  end

  # Pour les mots du scénodico
  #   Balise '{% mot <id> <le mot> %}'
  #
  class ExergueTags < Liquid::Tag
    include TagsFacilitatorModule
    def initialize(tag_name, str, token)
      super
      @input = str.strip
    end
    def render(context)
      EXERGUE_TAG % [@input]
    end
    EXERGUE_TAG = '<span class="exergue">%s</span>'
  end

  # Pour les questions Checkup
  #   Balise '{% checkup <id string> <la question> %}'
  #
  class ImageTags < Liquid::Tag
    include TagsFacilitatorModule
    def initialize(tag_name, str, token)
      super
      @input = str.strip.split(' ')
      @path   = @input.shift
      @class  = @input.shift
      @legend = @input.join(' ')
      @legend = nil if @legend == ""
    end
    def render(context)
      dossier_images = context.registers[:page]['dossier_images']
      @path = @path.prepend("#{dossier_images}/") if dossier_images
      template = if @legend.nil?
                    IMAGE_SIMPLE_TAG
                  else
                    IMAGE_WITH_LEGEND_TAG
                  end
      @class = '' if ['none', 'nil'].include?(@class)
      template % {path: @path, class: @class, legend: @legend, alt: (@legend || "Image #{@path}")}
    end
    IMAGE_SIMPLE_TAG = '<img src="/img/%{path}" class="%{class}" alt="%{alt}" />'.freeze
    IMAGE_WITH_LEGEND_TAG = <<-HTML.freeze
<div class="image-in-cadre %{class}">
<div class="image"><img src="/img/%{path}" /></div>
<div class="legend"><span class="legend">%{legend}</span></div>
</div>
HTML
  end

  # Pour les vidéos YouTube
  #   Balise '{% youtube <id string> %}'
  #
  class YouTubeTags < Liquid::Tag
    def initialize(tag_name, str, token)
      super
      @input = str.strip.split(' ')
      @youtube_id = @input.shift
      @class = @input.shift
      @class = nil if ['none','nil'].include?(@class)
      @legend = @input.join(' ')
      @legend = nil if @legend == ""
    end
    def render(context)
      # puts "@youtube_id dans render : #{@youtube_id.inspect}"
      div = FRAME_YOUTUBE % {yt_id: @youtube_id, class: @class}
      div = FRAME_YOUTUBE_WITH_LEGEND % {yt_iframe: div, legend: @legend} if @legend
      return div
    end
# src="https://www.youtube-nocookie.com/embed/%{youtube_id}?wmode=transparent&amp;vq=hd1080"
# FRAME_YOUTUBE = <<-HTML
# <div class="div-youtube %{class}">
#   <iframe
#     class="youtube-container"
#     src="https://www.youtube-nocookie.com/embed/%{yt_id}?wmode=transparent&amp;vq=hd1080"
#     frameborder="0"
#     allowfullscreen="true">
#   </iframe>
# </div>
# HTML
FRAME_YOUTUBE = <<-HTML
<div class="div-youtube %{class}">
<iframe
  src="https://www.youtube.com/embed/%{yt_id}"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen></iframe>
</div>
HTML

FRAME_YOUTUBE_WITH_LEGEND = <<-HTML
<div class="image-in-cadre">
  <div class="image">
    %{yt_iframe}
  </div>
  <div class="legend">
    <span class="legend">%{legend}</span>
  </div>
</div>
HTML
  end

  # Pour les mots technique
  #   Balise '{% tt <id> <le mot> %}'
  #
  class MotTechniqueTags < Liquid::Tag
    include TagsFacilitatorModule
    def initialize(tag_name, str, token)
      super
      @input = str.strip
    end
    def render(context)
      MOT_TAG % {mot: @input}
    end
    MOT_TAG = '<span class="tt">%{mot}</span>'
  end

  # Pour les liens courants du site
  #   Balise '{% lien <nom symbolique> %}'
  #
  # Ces liens sont définis dans le fichier _data/liens.yml
  #
  class LienTags < Liquid::Tag
    include TagsFacilitatorModule
    def self.get_data_lien(id)
      @data_liens ||= YAML.load_file('./_data/liens.yml')
      @data_liens[id]
    end
    def initialize(tag_name, str, token)
      super
      @input = str.strip.split(' ')
      @id = @input.shift
      @titre = @input.join(' ')
      @titre = nil if @titre == ''
    end
    def render(context)
      data_lien = self.class.get_data_lien(@id)
      site = context.registers[:site]
      jpage = Jekyll::Page.new(site, site.baseurl, File.dirname(data_lien['location']), File.basename(data_lien['location']))
      titre = if @titre == "alt"
                data_lien['titre_alt']
              else
                @titre || jpage.data['titre']
              end
      LIEN_TAG % {href: jpage.permalink, titre: titre}
    end
    LIEN_TAG = '<a href="%{href}">%{titre}</a>'
  end

end

Liquid::Template.register_tag('date', Jekyll::DateTags)
Liquid::Template.register_tag('exergue', Jekyll::ExergueTags)
Liquid::Template.register_tag('image', Jekyll::ImageTags)
Liquid::Template.register_tag('youtube', Jekyll::YouTubeTags)
Liquid::Template.register_tag('lien', Jekyll::LienTags)
