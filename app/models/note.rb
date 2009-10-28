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

class Note

  def self.userStoreTransport
    Thrift::HTTPClientTransport.new(AppConfig.evernote['userStoreUrl'])
  end

  def self.userStoreProtocol
    Thrift::BinaryProtocol.new(userStoreTransport)
  end

  def self.userStore
    Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)
  end

  def self.versionOK
    userStore.checkVersion(
      "Ruby EDAMTest",
      Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
      Evernote::EDAM::UserStore::EDAM_VERSION_MINOR
    )
  end

  def self.version_ok!
    raise "Is my EDAM protocol version up to date?  #{versionOK}" unless versionOK
  end

  def self.authResult
    version_ok!
    userStore.authenticate(
      AppConfig.evernote['username'],
      AppConfig.evernote['password'],
      AppConfig.evernote['consumerKey'],
      AppConfig.evernote['consumerSecret']
    )
  end

  def self.user
    authResult.user
  end

  def self.noteStoreUrl
    AppConfig.evernote['noteStoreUrlBase'] + user.shardId
  end

  def self.noteStoreTransport

    Thrift::HTTPClientTransport.new(noteStoreUrl)
  end

  def self.noteStoreProtocol
    Thrift::BinaryProtocol.new(noteStoreTransport)
  end

  def self.noteStore
    Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)
  end

  def self.notebook
    noteStore.getPublicNotebook(user.id, AppConfig.evernote['public_notebooks']['marcinmisnotebook'])
  end

  def self.find_all
    raise 'Write me. Please!!!'
  end

end
