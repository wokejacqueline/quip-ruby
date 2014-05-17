require 'unirest'

module Quip
  class QuipClient
    attr_reader :access_token, :client_id, :client_secret,
                :base_url, :request_timeout

    def initialize(options)
      @access_token = options.fetch(:access_token)
      @client_id = options.fetch(:client_id, nil)
      @client_secret = options.fetch(:client_secret, nil)
      @base_url = options.fetch(:base_url, 'https://platform.quip.com/1')
      @request_timeout = options.fetch(:request_timeout, 10)
    end

    def get_authenticated_user
      get_json('users/current')
    end

    def get_folder(folder_id)
      get_json("folders/#{folder_id}")
    end

    def get_thread(thread_id)
      get_json("threads/#{thread_id}")
    end

    def get_threads(thread_ids)
      get_json("threads/?ids=#{thread_ids.join(',')}")
    end

    def get_recent_threads(count = 10, max_usec = nil)
      get_json("threads/recent?count=#{count}&max_updated_usec=#{max_usec}")
    end

    def create_document(content, options = {})
      post_json("threads/new-document", {
        content: content,
        format: options.fetch(:format, 'html'),
        title: options.fetch(:title, nil),
        member_ids: options.fetch(:member_ids, []).join(',')
      })
    end

    def edit_document(thread_id, content = nil, options = {})
      post_json("threads/edit-document", {
        thread_id: thread_id,
        content: content,
        location: options.fetch(:location, 0),
        section_id: options.fetch(:section_id, nil),
        format: options.fetch(:format, 'html')
      })
    end

    def get_messages(thread_id)
      get_json("messages/#{thread_id}")
    end

    def post_message(thread_id, message)
      post_json("messages/new", {thread_id: thread_id, content: message})
    end

    private

    def get_json(path)
      response = Unirest.get("#{base_url}/#{path}", headers: {
        'Authorization' => "Bearer #{access_token}"
      })

      response.body
    end

    def post_json(path, data)
      response = Unirest.post("#{base_url}/#{path}", headers: {
        'Authorization' => "Bearer #{access_token}" }, 
        parameters: data
      )

      response.body
    end
  end
end