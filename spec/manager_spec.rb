require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-sqlite-adapter'
require 'ixtlan/gettext/models'
require 'ixtlan/gettext/manager'

DataMapper.setup(:default, "sqlite::memory:")
DataMapper.auto_migrate!

describe Ixtlan::Gettext::Manager do

  include FastGettext::Translation

  subject { Ixtlan::Gettext::Manager.new }

  let( :date ) { DateTime.now( 0 ) }

  let( :en ) { Ixtlan::Gettext::Locale.first_or_create( :code => 'en',
                                                        :updated_at => date ) }
  let( :de ) { Ixtlan::Gettext::Locale.first_or_create( :code => 'de',
                                                        :updated_at => date ) }

  let( :test ) { Ixtlan::UserManagement::Domain.first_or_create( :name => 'test',
                                                                 :updated_at => date ) }

  let( :key ) {  Ixtlan::Gettext::TranslationKey.first_or_create( :name => 'word',
                                                                  :updated_at => date ) }

  let( :word ) { Ixtlan::Gettext::Translation.first_or_create( :text => 'word_en_default',
                                                               :updated_at => date,
                                                               :translation_key => key,
                                                               :locale => en ) }
  let( :wort ) { Ixtlan::Gettext::Translation.first_or_create( :text => 'wort_de_default',
                                                               :updated_at => date,
                                                               :translation_key => key,
                                                               :locale => de ) }
  let( :word_test ) { Ixtlan::Gettext::Translation.first_or_create( :text => 'word_en_test',
                                                                    :updated_at => date,
                                                                    :translation_key => key,
                                                                    :domain => test,
                                                                    :locale => en ) }
  let( :wort_test ) { Ixtlan::Gettext::Translation.first_or_create( :text => 'wort_de_test',
                                                                    :updated_at => date,
                                                                    :translation_key => key,
                                                                    :domain => test,
                                                                    :locale => de ) }

  before do
    # setup DB :)
    en
    de
    test

    word
    word_test
    wort
    wort_test

    FastGettext.default_locale = en.code
  end

  it 'lookup' do
    subject.use( en.code )
    _('word').must_equal "word_en_default"
    subject.use( en.code, test.name )
    _('word').must_equal "word_en_test"
    subject.use( de.code )
    _('word').must_equal "wort_de_default"
    subject.use( de.code, test.name )
    _('word').must_equal "wort_de_test"

    wort_test.destroy!
p Ixtlan::Gettext::TranslationKey.all
    subject.flush_caches

    subject.use( en.code )
    _('word').must_equal "word_en_default"
    subject.use( en.code, test.name )
    _('word').must_equal "word_en_test"
    subject.use( de.code )
    _('word').must_equal "wort_de_default"
    subject.use( de.code, test.name )
    _('word').must_equal "wort_de_default"

    wort.destroy!
    subject.flush_caches

    subject.use( en.code )
    _('word').must_equal "word_en_default"
    subject.use( en.code, test.name )
    _('word').must_equal "word_en_test"
    subject.use( de.code )
    _('word').must_equal "word"
    subject.use( de.code, test.name )
    _('word').must_equal "word"

    word.destroy!
    subject.flush_caches

    subject.use( en.code )
    _('word').must_equal 'word'
    subject.use( en.code, test.name )
    _('word').must_equal "word_en_test"
    subject.use( de.code )
    _('word').must_equal 'word'
    subject.use( de.code, test.name )
    _('word').must_equal "word"

    word_test.destroy!
    subject.flush_caches
    subject.use( en.code )
    _('word').must_equal 'word'
    subject.use( en.code, test.name )
    _('word').must_equal 'word'
    subject.use( de.code )
    _('word').must_equal 'word'
    subject.use( de.code, test.name )
    _('word').must_equal 'word'
  end
end
