# frozen_string_literal: true

def louchebem_word(word)
  # On crée un tableau des lettres du mot (en miniscule)
  word_letters = word.downcase.chars # .chars == .split("")

  still_have_consonnants_to_split = true
  suffixes = %w[em é ji oc ic uche ès]
  first_consonnants = []
  rest_of_letters = []

  # Si le premier caractère de word n'est PAS une voyelle
  if ![a, e, i, o, u, y].include?(word_letters[0])
    # Pour chaque LETTER prise une à une dans WORD_LETTERS
    word_letters.each do |letter|
      if still_have_consonnants_to_split

        # Si LETTER est une voyelle, on a fini de chercher les premières consonnes
        if [a, e, i, o, u, y].include?(letter)
          rest_of_letters << letter
          still_have_consonnants_to_split = false
        else # Sinon, LETTER est une consonne qu'on met dans le tableau des premières consonnes
          first_consonnants << letter
        end

      else
        rest_of_letters << letter
      end
    end # Fin de l'itération

    "l#{rest_of_letters.join}#{first_consonnants.join}#{suffixes.sample}"
  else
    "l#{word}#{suffixes.sample}"
  end
end

def louchebemize(sentence)
  sentence.split(" ").map do |word|
    louchebem_word(word)
  end.join(" ")
end

## !!! Ça ne marche pas s'il y a des signes de ponctuation dans la phrase.
## A changer
