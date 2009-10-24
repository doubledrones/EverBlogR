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

  def self.notebook
    userStoreTransport = Thrift::HTTPClientTransport.new(AppConfig.evernote['userStoreUrl'])
    userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
    userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)
    versionOK = userStore.checkVersion("Ruby EDAMTest",
                                    Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                                    Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
    raise "Is my EDAM protocol version up to date?  #{versionOK}" unless versionOK
    authResult = userStore.authenticate(AppConfig.evernote['username'], AppConfig.evernote['password'],
                                        AppConfig.evernote['consumerKey'], AppConfig.evernote['consumerSecret'])
    user = authResult.user
    authToken = authResult.authenticationToken
    
    noteStoreUrl = AppConfig.evernote['noteStoreUrlBase'] + user.shardId
    noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
    noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
    noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

    noteStore.getPublicNotebook(user.id, AppConfig.evernote['public_notebooks']['marcinmisnotebook'])
  end

  def self.find_all
    raise 'Write me. Please!!!'
  end

end
