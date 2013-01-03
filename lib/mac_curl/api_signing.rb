require 'playup_helpers'

module MacCurl
  module ApiSigning
    def api_key_header_value_for(api_key, api_secret, path)
      "#{api_key} #{Playup::Signature.new(api_secret, api_key, path)}"
    end
  end
end
