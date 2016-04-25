class LanguageLink < Link
   validates :language_code, inclusion: { in: Language.language_list }
   validates :alphabeth_code, inclusion: { in: proc { |l|
      Language.alphabeth_list_for( l.language_code ) } } ; end
