require_relative '../link'

class LanguageLink < Link
   validates :language_code, inclusion: { in: Language::LANGUAGE_TREE.keys }
   validates :alphabeth_code, inclusion: { in: Language::ALPHABETH_LIST } ; end
