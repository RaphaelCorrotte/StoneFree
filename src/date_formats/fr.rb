module StoneFree::Locales
  def fr
    days = "lundi!mardi!mercredi!jeudi!vendredi!samedi!dimanche".split("!")
    short_days = "lun!mar!mer!jeu!ven!sam!dim".split("!")
    months = "janvier!février!mars!avril!mai!juin!juillet!août!septembre!octobre!novembre!décembre".split("!")
    short_months = "janv!févr!mars!avr!mai!juin!juil!août!sept!oct!nov!déc".split("!")
    formats = Hash[
      :long => "DDDD DD MMMM YYYY à HH:mm",
      :short => "dddd DD mmmm YYYY à HH:mm",
      :numeric => "DD/MM/YYYY",
      :time => "HH:mm:ms"
    ]
    relative_time = Hash[
      :future => "dans &t",
      :past => "il y a &t",
      :s => 'quelques secondes',
      :m => 'une minute',
      :mm => '&mm minutes',
      :h => 'une heure',
      :hh => '&hh heures',
      :d => 'un jour',
      :dd => '&jj jours',
      :M => 'un mois',
      :MM => '&MM mois',
      :y => 'un an',
      :yy => '&yy ans'
    ]

    {
      :days => days,
      :short_days => short_days,
      :months => months,
      :short_months => short_months,
      :formats => formats,
      :ordinal => ->(n) do
        n == 1 ? "#{n}er" : n
      end,
      :relative_time => relative_time
    }
  end
  module_function :fr
end