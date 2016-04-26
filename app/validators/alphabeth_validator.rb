class AlphabethValidator < ActiveModel::EachValidator
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
   IVERIAN_CAPITAL = 'ა-ჺჽ'
   IVERIAN_STROKE = 'ა-ჺჽ'
   ROMANIAN_CAPITAL = 'A-ZĂÂÎȘȚ'
   ROMANIAN_STROKE = 'a-zăâîșț'
   OLD_ENGLISH_CAPITAL = 'A-IL-PR-UW-YÆÐꝽÞǷĊĠĀĒĪŌŪ'
   OLD_ENGLISH_STROKE = 'a-il-pr-uw-yæðᵹſþƿċġāēīūō'
   FRENCH_CAPITAL = 'A-ZŒÆÇÀÂÎÏÛÙÜÉÈÊËÔŸÑ'
   FRENCH_STROKE = 'a-zœæçàâîïûùüéèêëôÿñ'
   SPANISH_CAPITAL = 'A-ZÑÁÉÍÓÚÜÏ'
   SPANISH_STROKE = 'a-zñáéíóúüï'

   RUSSIAN_SYNTAX = ' .,:;!/-'
   CSLAV_SYNTAX = ' .,:;'
   SERBIAN_SYNTAX = ' .,/-'
   GREEK_SYNTAX = ' .,:;!/-'
   BULGARIAN_SYNTAX = ' .,:;!/-'
   LATIN_SYNTAX = ' .,:;!/-'
   IRISH_SYNTAX = ' .,:;!/-'
   CZECH_SYNTAX = ' .,:;!/-'
   ENGLISH_SYNTAX = ' .,:;!/-'
   ITALIAN_SYNTAX = ' .,:;!/-'
   ARMENIAN_SYNTAX = ' .,:;!/-'
   IVERIAN_SYNTAX = ' .,:;!/-'
   ROMANIAN_SYNTAX = ' .,:;!/-'
   OLD_ENGLISH_SYNTAX = ' .,:;!/-'
   FRENCH_SYNTAX = ' .,:;!/-'
   SPANISH_SYNTAX = ' .,:;!/-'

   UPCHAR = RUSSIAN_CAPITAL + CSLAV_CAPITAL + SERBIAN_CAPITAL + GREEK_CAPITAL +
      ENGLISH_CAPITAL + LATIN_CAPITAL + CZECH_CAPITAL + ARMENIAN_CAPITAL +
      ROMANIAN_CAPITAL + OLD_ENGLISH_CAPITAL + IVERIAN_CAPITAL
   DOWNCHAR = RUSSIAN_STROKE + CSLAV_STROKE + SERBIAN_STROKE + GREEK_STROKE +
      ENGLISH_STROKE + LATIN_STROKE + CZECH_STROKE + ARMENIAN_STROKE +
      IVERIAN_STROKE + ROMANIAN_STROKE + OLD_ENGLISH_STROKE
   ACCENT = GREEK_ACCENT + RUSSIAN_ACCENT + CSLAV_ACCENT
   CHAR = DOWNCHAR + UPCHAR

   # TODO уравнять с LANGUAGE_TREE.alphabeths
   SYNTAX_TABLE = {
      :ру => RUSSIAN_SYNTAX,
      :цс => CSLAV_SYNTAX,
      :ср => SERBIAN_SYNTAX,
      :гр => GREEK_SYNTAX,
      :ан => ENGLISH_SYNTAX,
      :чх => CZECH_SYNTAX,
      :ир => IRISH_SYNTAX,
      :си => IRISH_SYNTAX,
      :ла => LATIN_SYNTAX,
      :бг => BULGARIAN_SYNTAX,
      :ит => ITALIAN_SYNTAX,
      :ар => ARMENIAN_SYNTAX,
      :ив => IVERIAN_SYNTAX,
      :рм => ROMANIAN_SYNTAX,
      :са => OLD_ENGLISH_SYNTAX,
      :фр => FRENCH_SYNTAX,
      :ис => SPANISH_SYNTAX,
   }

   MATCH_TABLE = {
      :ру => "#{RUSSIAN_CAPITAL}#{RUSSIAN_STROKE}#{RUSSIAN_ACCENT}",
      :цс => "#{CSLAV_CAPITAL}#{CSLAV_STROKE}#{CSLAV_ACCENT}",
      :ср => "#{SERBIAN_CAPITAL}#{SERBIAN_STROKE}",
      :гр => "#{GREEK_CAPITAL}#{GREEK_STROKE}#{GREEK_ACCENT}",
      :ан => "#{ENGLISH_CAPITAL}#{ENGLISH_STROKE}",
      :чх => "#{CZECH_CAPITAL}#{CZECH_STROKE}#{CZECH_ACCENT}",
      :ир => "#{IRISH_CAPITAL}#{IRISH_STROKE}",
      :си => "#{IRISH_CAPITAL}#{IRISH_STROKE}",
      :ла => "#{LATIN_CAPITAL}#{LATIN_STROKE}",
      :бг => "#{BULGARIAN_CAPITAL}#{BULGARIAN_STROKE}",
      :ит => "#{ITALIAN_CAPITAL}#{ITALIAN_STROKE}",
      :ар => "#{ARMENIAN_CAPITAL}#{ARMENIAN_STROKE}",
      :ив => "#{IVERIAN_STROKE}",
      :рм => "#{ROMANIAN_CAPITAL}#{ROMANIAN_STROKE}",
      :са => "#{OLD_ENGLISH_CAPITAL}#{OLD_ENGLISH_STROKE}",
      :фр => "#{FRENCH_CAPITAL}#{FRENCH_STROKE}",
      :ис => "#{SPANISH_CAPITAL}#{SPANISH_STROKE}",
   }

   def plain_options
      [ options[:with], options[:in] ].flatten.compact.map do |o|
         case o
         when Hash
            o.map { |(k, v)| { k => v } }
         when String, Symbol
            { o => true }
         when Array
            o.map { |x| { x => true } }
         else
            raise "Target of kind #{o.class} is unsupported" ;end ;end
         .flatten.map { |x| [ x.keys.first, x.values.first ] }.to_h ;end

   def validate_each(record, attribute, value)
      o = plain_options
      res = MATCH_TABLE[ record.language_code.to_s.to_sym ]
      if res && ! o.keys.include?( :nosyntax )
         res += SYNTAX_TABLE[ record.language_code.to_s.to_sym ] ;end
      if res && o.keys.include?( :allow )
         res += o[ :allow ] ;end

      if res && value.present? && value !~ ( re = /^[#{res}]+$/ )
         chars = value.unpack( "U*" ).map do |c|
            c.chr !~ re && c || nil end.compact.uniq.sort.pack( "U*" )
         record.errors[ attribute ] <<
         I18n.t( 'activerecord.errors.invalid_language_char',
            language: record.language_code,
            chars: chars ) ; end ; end ; end