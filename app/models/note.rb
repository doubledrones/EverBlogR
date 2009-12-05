require "digest/md5"
require "thrift/types"
require "thrift/struct"
require "thrift/protocol/base_protocol"
require "thrift/protocol/binary_protocol"
require "thrift/transport/base_transport"
require "thrift/transport/http_client_transport"
require "Evernote/EDAM/user_store"
require "Evernote/EDAM/user_store_constants.rb"
require "Evernote/EDAM/note_store"
require "Evernote/EDAM/limits_constants.rb"

class Note < Evernote::EDAM::Type::Note

  @@find_notes = {}

  NOTE_OFFSET = 0
  NOTE_NUMBER = 10

  def self.notebook_name
    raise "Implement me"
  end

  def self.notebook
    note_store.getPublicNotebook(user.id, notebook_name)
  end

  def self.find_all(offset = NOTE_OFFSET, number = NOTE_NUMBER)
    get_notes(offset, number)
  end

  def self.find_first(offset = NOTE_OFFSET)
    get_notes(offset, 1).first # self # Evernote::EDAM::Type::Note
  end

  def created_at
    Time.at(created_at_unix)
  end

  private

    def self.user_store_transport
      @@user_store_transport ||= Thrift::HTTPClientTransport.new(AppConfig.evernote['userStoreUrl'])
    end

    def self.user_store_protocol
      @@user_store_protocol ||= Thrift::BinaryProtocol.new(user_store_transport)
    end

    def self.user_store
      @@user_store ||= Evernote::EDAM::UserStore::UserStore::Client.new(user_store_protocol)
    end

    def self.version_ok?
      @@version_ok ||= user_store.checkVersion(
        "Ruby EDAMTest",
        Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
        Evernote::EDAM::UserStore::EDAM_VERSION_MINOR
      )
    end

    def self.version_ok!
      raise "Is my EDAM protocol version up to date?  #{version_ok?}" unless version_ok?
    end

    def self.auth_result
      version_ok!
      @@auth_result ||= user_store.authenticate(
        AppConfig.evernote['username'],
        AppConfig.evernote['password'],
        AppConfig.evernote['consumerKey'],
        AppConfig.evernote['consumerSecret']
      )
    end

    def self.user
      auth_result.user
    end

    def self.note_store_url
      AppConfig.evernote['noteStoreUrlBase'] + user.shardId
    end

    def self.note_store_transport
      @@note_store_transport ||= Thrift::HTTPClientTransport.new(note_store_url)
    end

    def self.note_store_protocol
      @@note_store_protocol ||= Thrift::BinaryProtocol.new(note_store_transport)
    end

    def self.note_store
      @@note_store ||= Evernote::EDAM::NoteStore::NoteStore::Client.new(note_store_protocol)
    end

    def self.authentication_token
      @@authentication_token ||= auth_result.authenticationToken
    end

    def initialize(note)
      note.struct_fields.each do |struct_fields|
        # assign values, create methods
      end
    end

    def self.get_notes(offset = NOTE_OFFSET, number = NOTE_NUMBER)
      find_notes(offset, number).notes.collect { |note| self.new(note) }
    end

    def self.find_notes(offset = NOTE_OFFSET, number = NOTE_NUMBER)
      note_store.findNotes(authentication_token, Evernote::EDAM::NoteStore::NoteFilter.new, offset, number)
    end

    def created_at_unix
      created / 1000
    end

end
