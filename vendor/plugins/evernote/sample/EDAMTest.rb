#
# To run (Unix):
#   ruby -I../../lib/ruby -I../../lib/ruby/Evernote/EDAM EDAMTest.rb myuser mypass
#

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

#
# Configure these based on the API key you received from Evernote
#
consumerKey = "en-edamtest"
consumerSecret = "0123456789abcdef"

userStoreUrl = "https://sandbox.evernote.com/edam/user"
noteStoreUrlBase = "http://sandbox.evernote.com/edam/note/"

if (ARGV.size < 2)
  puts "Arguments:  <username> <password>"
  exit(1)
end

username = ARGV[0]
password = ARGV[1]

userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)

versionOK = userStore.checkVersion("Ruby EDAMTest",
                                Evernote::EDAM::UserStore::EDAM_VERSION_MAJOR,
                                Evernote::EDAM::UserStore::EDAM_VERSION_MINOR)
puts "Is my EDAM protocol version up to date?  #{versionOK}"
if (!versionOK)
  exit(1)
end

authResult = userStore.authenticate(username, password,
                                    consumerKey, consumerSecret)
user = authResult.user
authToken = authResult.authenticationToken
puts "Authentication was successful for #{user.username}"
puts "Authentication token = #{authToken}"

noteStoreUrl = noteStoreUrlBase + user.shardId
noteStoreTransport = Thrift::HTTPClientTransport.new(noteStoreUrl)
noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)

notebooks = noteStore.listNotebooks(authToken)
puts "Found #{notebooks.size} notebooks:"
defaultNotebook = notebooks[0]
notebooks.each { |notebook| 
  puts "  * #{notebook.name}"
  if (notebook.defaultNotebook)
    defaultNotebook = notebook
  end
}

puts
puts "Creating a new note in the default notebook: #{defaultNotebook.name}"
puts

image = File.open("enlogo.png", "rb") { |io| io.read }
hashFunc = Digest::MD5.new
hashHex = hashFunc.hexdigest(image)

data = Evernote::EDAM::Type::Data.new()
data.size = image.size
data.bodyHash = hashHex
data.body = image

resource = Evernote::EDAM::Type::Resource.new()
resource.mime = "image/png"
resource.data = data

note = Evernote::EDAM::Type::Note.new()
note.notebookGuid = defaultNotebook.guid
note.title = "Test note from ENTest.rb"
note.content = '<?xml version="1.0" encoding="UTF-8"?>' +
  '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml.dtd">' +
  '<en-note>Here is the Evernote logo:<br/>' +
  '<en-media type="image/png" hash="' + hashHex + '"/>' +
  '</en-note>'
note.created = Time.now.to_i * 1000
note.updated = note.created
note.resources = [ resource ]

createdNote = noteStore.createNote(authToken, note)

puts "Note was created, GUID = #{createdNote.guid}"

