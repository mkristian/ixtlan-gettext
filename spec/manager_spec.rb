require 'dm-migrations'
require 'dm-validations'
require 'dm-timestamps'
require 'dm-sqlite-adapter'
require 'ixtlan/gettext/models'
require 'ixtlan/gettext/manager'


describe Ixtlan::Gettext::Manager do

  include FastGettext::Translation

  subject { Ixtlan::Gettext::Manager.new }

  let( :en ) { @en }
  let( :de ) { @de }

  let( :test ) { @test }

  let( :key ) {  @key }

  let( :word ) { @word }
  let( :wort ) { @wort }
  let( :word_test ) { @word_test }
  let( :wort_test ) { @wort_test }

  before do
    DataMapper.setup(:default, "sqlite::memory:")
    DataMapper.auto_migrate!
    # setup DB :)
    date = DateTime.now( 0 )
    @en = Ixtlan::Gettext::Locale.first_or_create( :code => 'en',
                                                   :updated_at => date )
    @de = Ixtlan::Gettext::Locale.first_or_create( :code => 'de',
                                                        :updated_at => date )
    # get the predefined in place
    Ixtlan::UserManagement::Domain.ALL
    @default = Ixtlan::UserManagement::Domain.DEFAULT
    @test = Ixtlan::UserManagement::Domain.first_or_create( :name => 'test',
                                                            :updated_at => date )
    @key = Ixtlan::Gettext::TranslationKey.first_or_create( :name => 'word',
                                                            :updated_at => date )
    @word = Ixtlan::Gettext::Translation.first_or_create( :text => 'word_en_default',
                                                          :updated_at => date,
                                                          :translation_key => key,
                                                          :locale => @en,
                                                          :domain =>  @default )
    @word_test = Ixtlan::Gettext::Translation.first_or_create( :text => 'word_en_test',
                                                               :updated_at => date,
                                                               :translation_key => key,
                                                               :domain => @test,
                                                               :locale => @en )
    @wort = Ixtlan::Gettext::Translation.first_or_create( :text => 'wort_de_default',
                                                          :updated_at => date,
                                                          :translation_key => key,
                                                          :locale => @de,
                                                          :domain =>  @default )
    @wort_test = Ixtlan::Gettext::Translation.first_or_create( :text => 'wort_de_test',
                                                               :updated_at => date,
                                                               :translation_key => key,
                                                               :domain => @test,
                                                               :locale => @de )
    
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

    wort_test.reload.destroy!
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
