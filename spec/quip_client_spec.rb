require 'spec_helper'
require 'quip'

describe Quip::QuipClient do
  specify '#initialize' do
    client = Quip::QuipClient.new(
      access_token: '1234',
      client_id: 1,
      client_secret: 'secret',
      base_url: 'http://example.com',
      request_timeout: 30)

    expect(client.access_token).to eq('1234')
    expect(client.client_id).to eq(1)
    expect(client.client_secret).to eq('secret')
    expect(client.base_url).to eq('http://example.com')
    expect(client.request_timeout).to eq(30)
  end

  context 'authenticated client' do
    let(:client) { Quip::QuipClient.new(access_token: 'example') }

    specify '#get_authenticated_user' do
      stub_request(:get, client.base_url+'/users/current')
        .to_return(body: '{"name": "Joffrey Baratheon"}')

      user = client.get_authenticated_user()
      expect(user['name']).to eq('Joffrey Baratheon')
    end

    specify '#get_folder' do
      stub_request(:get, client.base_url+'/folders/ZYbAOAbHPyR')
        .to_return(body: '{"folder": {"title": "The true king of Westeros"}}')

      desktop = client.get_folder('ZYbAOAbHPyR')
      expect(desktop['folder']['title']).to eq('The true king of Westeros')
    end

    specify '#get_thread' do
      stub_request(:get, client.base_url+'/threads/YeXAAA2Uwb3')
        .to_return(body: '{"html": "<h1>Valor Morghulis</h1>"}')

      thread = client.get_thread('YeXAAA2Uwb3')
      expect(thread['html']).to eq('<h1>Valor Morghulis</h1>')
    end

    specify '#get_threads' do
      stub_request(:get, client.base_url+'/threads/')
        .with(query: {"ids" => "CQXAAAP8MkR,YTWAAAiKUqp" })
        .to_return(body: '{
          "CQXAAAP8MkR": {"html": "<h1>Valar Morghulis</h1>"}, 
          "YTWAAAiKUqp": {"html": "<h1>Valar Dohaeris</h1>"}
        }')

      threads = client.get_threads(['CQXAAAP8MkR','YTWAAAiKUqp'])
      expect(threads['CQXAAAP8MkR']['html']).to eq('<h1>Valar Morghulis</h1>')
      expect(threads['YTWAAAiKUqp']['html']).to eq('<h1>Valar Dohaeris</h1>')
    end

    specify '#get_recent_threads' do
      stub_request(:get, client.base_url+'/threads/recent')
        .with(query: {
          "count" => 2,
          "max_updated_usec" => 1399749767280351
        })
        .to_return(body: '{
          "JLEAAAn9lAQ": {"html": "<h1>Kingslayer</h1>"}, 
          "DWRAOA5qGV9": {"thread": {"updated_usec": 1399749767280349}}
        }')

      recent = client.get_recent_threads(2, 1399749767280351)
      expect(recent.length).to eq(2)
      expect(recent['DWRAOA5qGV9']['thread']['updated_usec']).to be < 1399749767280351
    end

    specify '#create_document' do
      stub_request(:post, client.base_url+'/threads/new-document')
        .to_return(body: '{"html": "<h1>House Lannister</h1>"}')

      document = client.create_document("<h1>House Lannister</h1>")
      expect(document['html']).to eq("<h1>House Lannister</h1>")
    end

    specify '#edit_document' do
      stub_request(:post, client.base_url+'/threads/edit-document')
        .to_return(body: '{
          "html": "<h1>House Stark</h1>",
          "thread": {"id": "IXbAAA6qefF"}
        }')

      document = client.edit_document("IXbAAA6qefF", "<h1>House Stark</h1>")
      expect(document['html']).to eq("<h1>House Stark</h1>")
      expect(document['thread']['id']).to eq("IXbAAA6qefF")
    end

    specify '#add_thread_members' do
      stub_request(:post, client.base_url+'/threads/add-members')
        .to_return(body: '{"user_ids": ["C3Rc3iR0b0"]}')

      members = client.add_thread_members("HTPAAAdSbAm", ["C3Rc3iR0b0"])
      expect(members['user_ids']).to eq(["C3Rc3iR0b0"])
    end

    specify '#remove_thread_members' do
      stub_request(:post, client.base_url+'/threads/remove-members')
        .to_return(body: '{"user_ids": []}')

      members = client.remove_thread_members("JZbAAAb9x5x", ["C3Rc3iR0b0"])
      expect(members['user_ids']).to eq([])
    end

    specify '#get_blob' do
      stub_request(:get, client.base_url+'/blob/JZbAAAb9x5x/BmUYIlBwV3_Yil')
        .to_return(body: '\x88\xE8\xFF\xD3T\x88\x00\x00\x00')

      blob = client.get_blob('JZbAAAb9x5x', 'BmUYIlBwV3_Yil')
      expect(blob).to eq('\x88\xE8\xFF\xD3T\x88\x00\x00\x00')
    end

    specify '#get_messages' do
      stub_request(:get, client.base_url+'/messages/OLJAAAo0ggF')
        .to_return(body: '[{"text": "I am the king! I will punish you."}]')

      messages = client.get_messages('OLJAAAo0ggF')
      expect(messages[0]['text']).to eq("I am the king! I will punish you.")
    end

    specify '#post_message' do
      stub_request(:post, client.base_url+'/messages/new')
        .to_return(body: '{"text": "The king can do as he likes!"}')

      message = client.post_message('YTWAAAiKUqp', "The king can do as he likes!")
      expect(message['text']).to eq("The king can do as he likes!")
    end
  end
end