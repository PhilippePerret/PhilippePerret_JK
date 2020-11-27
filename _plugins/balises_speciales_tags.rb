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
  class CheckupTags < Liquid::Tag
    include TagsFacilitatorModule
    class << self
      def new_id
        @last_id ||= 0
        @last_id += 1
      end #/ new_id
    end #/<< self
    def initialize(tag_name, str, token)
      super
      @input = str.strip
    end
    def render(context)
      CHECKUP_TAG % get_id_and_content_from_input(:question).merge(cb_id: "checkup-#{self.class.new_id}")
    end
    CHECKUP_TAG = '<div class="checkup"><input id="%{cb_id}" type="checkbox" /><label for="%{cb_id}">%{question}</label></div>'
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

Liquid::Template.register_tag('tt', Jekyll::MotTechniqueTags)
Liquid::Template.register_tag('personnage', Jekyll::PersonnageTags)
Liquid::Template.register_tag('checkup', Jekyll::CheckupTags)
