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

end
