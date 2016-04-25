class LanguageLink < Link
   validates :language_code, inclusion: { in: Language.language_list }
   validates :alphabeth_code, inclusion: { in: Language.alphabeth_list } ; end
