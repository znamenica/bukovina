module Bukovina::Parsers
   class BukovinaError < StandardError; end
   class BukovinaTypeError < BukovinaError; end
   class BukovinaIndexError < BukovinaError; end
   class BukovinaInvalidClass < BukovinaError; end
   class BukovinaInvalidLanguageError < BukovinaError; end
   class BukovinaInvalidContext < BukovinaError; end
   class BukovinaInvalidCharError < BukovinaError; end
   class BukovinaInvalidTokenError < BukovinaError; end
   class BukovinaInvalidEnumeratorError < BukovinaError; end
   class BukovinaInvalidVariatorError < BukovinaError; end
   class BukovinaEmptyRecord < BukovinaError; end
   class BukovinaNullNameLine < BukovinaError; end

   # TODO добавить проверку регвыра в проверяльщик модели
   RUSSIAN_CAPITAL = 'А-ЯЁ'
   RUSSIAN_STROKE = 'а-яё'
   RUSSIAN_ACCENT = '́'
   CSLAV_CAPITAL = 'А-ЬЮЅІѠѢѦѮѰѲѴѶѸѺѼѾꙖꙊ'
   CSLAV_STROKE = 'а-ьюєѕіѡѣѧѯѱѳѵѷѹѻѽѿꙗꙋ'
   CSLAV_ACCENT = '̀́̓̔҃҇҈҉꙽'
   SERBIAN_CAPITAL = 'ЂЈ-ЋЏА-ИК-Ш'
   SERBIAN_STROKE = 'ђј-ћа-ик-ш'
   GREEK_CAPITAL = 'ͶͲΑ-ΫϏϒϓϔϘϚϜϠϞϴϷϹϺϾϿἈ-ἏἘ-ἝἨ-ἯἸ-ἿὈ-ὍὙ-ὟὨ-Ὧᾈ-ᾏᾘ-ᾟᾨ-ᾯᾸ-ᾼῈ-ῌῘ-ΊῨ-ῬῸ-ῼΩΆ-Ώ'
   GREEK_STROKE = 'ά-ώϐϑϕ-ϗϙϛϝ-ϟϡ-ϳϵ-϶ϸϻϼᴦ-ᴪἀ-ἇἐ-ἕἠ-ἧἰ-ἷὀ-ὅὐ-ὗὠ-ὧὰ-ᾇᾐ-ᾗᾠ-ᾧᾰ-ᾷῂ-ῇῐ-ῗῠ-ῧῲ-ῷͻ-ͽͷΐά-ΰ'
   GREEK_ACCENT = 'ͺ͵΄᾽ι᾿῀῁῍῎῏῝῞῟῭΅`´῾'
   BULGARIAN_CAPITAL = 'А-ЪЬЮЯ'
   BULGARIAN_STROKE = 'а-ъьюя'
   LATIN_CAPITAL = 'A-IK-TVX-ZÆ'
   LATIN_STROKE = 'a-ik-tvx-zæ'
   IRISH_CAPITAL = 'A-IL-PR-U'
   IRISH_STROKE = 'a-il-pr-u'
   CZECH_CAPITAL = 'A-PR-VX-ZÁÉĚÍÓÚŮÝČĎŇŘŠŤŽ'
   CZECH_STROKE = 'a-pr-vx-záéěíóúůýčďňřšťž'
   CZECH_ACCENT = '́̌̊'
   ENGLISH_CAPITAL = 'A-Z'
   ENGLISH_STROKE = 'a-z'
   ITALIAN_CAPITAL = 'A-IL-VZ'
   ITALIAN_STROKE = 'a-il-vz'
   ARMENIAN_CAPITAL = 'Ա-Ֆ'
   ARMENIAN_STROKE = 'ա-և'
   IVERIAN_STROKE = 'ა-ჺჽ'
   ROMANIAN_CAPITAL = 'A-ZĂÂÎȘȚ'
   ROMANIAN_STROKE = 'a-zăâîșț'
   OLD_ENGLISH_CAPITAL = 'A-IL-PR-UW-YÆÐꝽÞǷĊĠĀĒĪŌŪ'
   OLD_ENGLISH_STROKE = 'a-il-pr-uw-yæðᵹſþƿċġāēīūō'

   UPCHAR = RUSSIAN_CAPITAL + CSLAV_CAPITAL + SERBIAN_CAPITAL + GREEK_CAPITAL +
      ENGLISH_CAPITAL + LATIN_CAPITAL + CZECH_CAPITAL + ARMENIAN_CAPITAL +
      ROMANIAN_CAPITAL + OLD_ENGLISH_CAPITAL
   DOWNCHAR = RUSSIAN_STROKE + CSLAV_STROKE + SERBIAN_STROKE + GREEK_STROKE +
      ENGLISH_STROKE + LATIN_STROKE + CZECH_STROKE + ARMENIAN_STROKE +
      IVERIAN_STROKE + ROMANIAN_STROKE + OLD_ENGLISH_STROKE
   ACCENT = GREEK_ACCENT + RUSSIAN_ACCENT + CSLAV_ACCENT
   CHAR = DOWNCHAR + UPCHAR

   MATCH_TABLE = {
      :ру => /^[#{RUSSIAN_CAPITAL}#{RUSSIAN_STROKE}#{RUSSIAN_ACCENT}][#{RUSSIAN_STROKE}#{RUSSIAN_ACCENT}]*$/,
      :цс => /^[#{CSLAV_CAPITAL}#{CSLAV_STROKE}#{CSLAV_ACCENT}][#{CSLAV_STROKE}#{CSLAV_ACCENT}]*$/,
      :ср => /^[#{SERBIAN_CAPITAL}#{SERBIAN_STROKE}][#{SERBIAN_STROKE}]*$/,
      :гр => /^[#{GREEK_CAPITAL}#{GREEK_STROKE}#{GREEK_ACCENT}][#{GREEK_STROKE}#{GREEK_ACCENT}]*$/,
      :ан => /^[#{ENGLISH_CAPITAL}#{ENGLISH_STROKE}][#{ENGLISH_STROKE}]*$/,
      :чх => /^[#{CZECH_CAPITAL}#{CZECH_STROKE}#{CZECH_ACCENT}][#{CZECH_STROKE}#{CZECH_ACCENT}]*$/,
      :ир => /^[#{IRISH_CAPITAL}#{IRISH_STROKE}][#{IRISH_STROKE}]*$/,
      :си => /^[#{IRISH_CAPITAL}#{IRISH_STROKE}][#{IRISH_STROKE}]*$/,
      :ла => /^[#{LATIN_CAPITAL}#{LATIN_STROKE}][#{LATIN_STROKE}]*$/,
      :бг => /^[#{BULGARIAN_CAPITAL}#{BULGARIAN_STROKE}][#{BULGARIAN_STROKE}]*$/,
      :ит => /^[#{ITALIAN_CAPITAL}#{ITALIAN_STROKE}][#{ITALIAN_STROKE}]*$/,
      :ар => /^[#{ARMENIAN_CAPITAL}#{ARMENIAN_STROKE}][#{ARMENIAN_STROKE}]*$/,
      :ив => /^[#{IVERIAN_STROKE}]+$/,
      :рм => /^[#{ROMANIAN_CAPITAL}#{ROMANIAN_STROKE}][#{ROMANIAN_STROKE}]*$/,
      :са => /^[#{OLD_ENGLISH_CAPITAL}#{OLD_ENGLISH_STROKE}][#{OLD_ENGLISH_STROKE}]*$/
   }
end

require 'bukovina/parsers/name'
require 'bukovina/parsers/patronymic'
