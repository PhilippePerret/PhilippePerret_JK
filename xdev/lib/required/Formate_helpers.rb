# encoding: UTF-8
# frozen_string_literal: true
JOUR = (3600 * 24)
MOIS = {
  1 => {court: 'jan', long: 'janvier'},
  2 => {court: 'fév', long: 'février'},
  3 => {court: 'mars', long: 'mars'},
  4 => {court: 'avr', long: 'avril'},
  5 => {court: 'mai', long: 'mai'},
  6 => {court: 'juin', long: 'juin'},
  7 => {court: 'juil', long: 'juillet'},
  8 => {court: 'aout', long: 'aout'},
  9 => {court: 'sept', long: 'septembre'},
  10 => {court: 'oct', long: 'octobre'},
  11 => {court: 'nov', long: 'novembre'},
  12 => {court: 'déc', long: 'décembre'}
}

DAYNAMES = [
  'Dimanche', 'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'
]

def formate_date(time = nil, options = nil)
  options ||= {}
  options.key?(:mois) || options.merge!(mois: :long)
  time ||= Time.now
  time = Time.at(time.to_i) unless time.is_a?(Time)
  mois = MOIS[time.month][options[:mois]]
  temp =  if time.day == 1
            ["1<sup>er</sup> #{mois} %Y"]
          else
            ["%-d #{mois} %Y"]
          end
  temp << "à %H:%M" if options[:time] || options[:hour]
  temp = temp.join(" ")
  d = "#{options[:jour] || options[:day] ? DAYNAMES[time.wday]+' ' : ''}#{time.strftime(temp)}"
  if options[:duree]
    now = Time.now
    jours = ((now - time).abs.to_f / JOUR).round
    laps =  if jours == 0
              'aujourd’hui'
            else
              s = jours > 1 ? 's' : '' ;
              mot = now > time ? 'il y a' : 'dans' ;
              "#{mot} #{jours} jour#{s}"
            end
    d = "#{d} <span class=\"small\">(#{laps})</span>"
  end
  return d
end #/ formate_date
