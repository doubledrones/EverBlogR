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

  it 'created_at_unix should be created divided by 1000' do
    note = Note.new
    note.should_receive(:created).and_return(1225243153000)
    note.created_at_unix.should == 1225243153
  end

  it 'created_at should return proper time from unix time in created_at_unix' do
    note = Note.new
    note.should_receive(:created_at_unix).and_return(1225243153)
    Time.should_receive(:at).with(1225243153).and_return(:time)
    note.created_at.should == :time
  end

end
