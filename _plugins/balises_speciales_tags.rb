module Jekyll
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
    include TagsFacilitatorModule
    def initialize(tag_name, str, token)
      super
      @input = str.strip
    end
    def render(context)
      DATE_TAG % [@input]
    end
    DATE_TAG = '<span class="date">%s</span>'
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

  # Pour les personnages
  #   Balise '{% personnage <nom> %}'
  #
  class PersonnageTags < Liquid::Tag
    include TagsFacilitatorModule
    def initialize(tag_name, str, token)
      super
      @input = str.strip
    end
    def render(context)
      PERSO_TAG % {nom: @input}
    end
    PERSO_TAG = '<span class="personnage">%{nom}</span>'
  end

end

Liquid::Template.register_tag('date', Jekyll::DateTags)
Liquid::Template.register_tag('exergue', Jekyll::ExergueTags)
Liquid::Template.register_tag('image', Jekyll::ImageTags)

Liquid::Template.register_tag('personnage', Jekyll::PersonnageTags)
