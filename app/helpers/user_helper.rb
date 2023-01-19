module UserHelper
  # gender
  def male
    'homme'
  end

  def female
    'femme'
  end

  def gender_choice
    [male, female]
  end

  # hair
  def black
    'noir'
  end

  def brown1
    'brun'
  end

  def chestnut
    'châtain'
  end

  def blond
    'blond'
  end

  def redhead
    'roux'
  end

  def grey
    'gris'
  end

  def white
    'blanc'
  end

  def other
    'autre'
  end

  def hair_choice
    [brown1, chestnut, blond, redhead, other]
  end

  # eye
  def brown2
    'marron'
  end

  def blue
    'bleu'
  end

  def green
    'vert'
  end

  def eye_choice
    [brown2, blue, green, other]
  end

  # choice
  def yes
    'oui'
  end

  def no
    'non'
  end

  def yes_no_choice
    [yes, no]
  end

  # shape
  def thin
    'fine'
  end

  def normal
    'normale'
  end

  def sport
    'sportive'
  end

  def kg
    'kg en trop'
  end

  def shape_choice
    [thin, normal, sport, kg]
  end

  # goal
  def friend
    'amitié'
  end

  def discuss
    'discuter'
  end

  def party
    "relation d'un soir"
  end

  def serious
    'relation sérieuse'
  end

  def goal_choice
    [friend, discuss, party, serious]
  end
end
