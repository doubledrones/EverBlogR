require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Note do

  it 'should return all notes from all public notebooks' do
    pending 'Write me. Please!!!'
  end

  describe 'noetbook' do
    before do
      @notebook ||= Note.notebook
    end

    it 'should return proper notebook' do
      @notebook.class.should == Evernote::EDAM::Type::Notebook
    end
  end

  describe 'find_all' do
    before do
      @find_all ||= Note.find_all
    end

    it 'should find first note' do
      @find_all.first.title.should == 'Welcome to Evernote!'
    end
  end

  describe 'find_first' do
    before do
      @find_first ||= Note.find_first
    end

    it 'should find first note' do
      @find_first.title.should == 'Welcome to Evernote!'
    end
  end

end
