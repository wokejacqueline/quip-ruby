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
      stub_request(:get, 'https://platform.quip.com/1/users/current')
        .to_return(body: '{"name": "Joffrey Baratheon"}')

      user = client.get_authenticated_user()
      expect(user['name']).to eq('Joffrey Baratheon')
    end

    specify '#get_folder' do
      stub_request(:get, 'https://platform.quip.com/1/folders/ZYbAOAbHPyR')
        .to_return(body: '{"folder":{"title": "The true king of Westeros"}}')

      desktop = client.get_folder('ZYbAOAbHPyR')
      expect(desktop['folder']['title']).to eq('The true king of Westeros')
    end

    specify '#get_thread' do
      stub_request(:get, 'https://platform.quip.com/1/threads/YeXAAA2Uwb3')
        .to_return(body: '{"html": "<h1>Valor Morghulis</h1>"}')

      thread = client.get_thread('YeXAAA2Uwb3')
      expect(thread['html']).to eq('<h1>Valor Morghulis</h1>')
    end

    specify '#get_messages' do
      stub_request(:get, 'https://platform.quip.com/1/messages/OLJAAAo0ggF')
        .to_return(body: '[{"text":"I am the king! I will punish you."}]')

      messages = client.get_messages('OLJAAAo0ggF')
      expect(messages[0]['text']).to eq("I am the king! I will punish you.")
    end
  end
end
