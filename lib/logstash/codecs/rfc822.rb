require "logstash/filters/base"
require "logstash/namespace"
require "logstash/timestamp"
require "stud/interval"
require "socket" # for Socket.gethostname


class LogStash::Codecs::RFC822 < LogStash::Codecs::Base
  config_name "rfc822"
  
  config :lowercase_headers, :validate => :boolean, :default => true
  config :strip_attachments, :validate => :boolean, :default => false

  # For multipart messages, use the first part that has this
  # content-type as the event message.
  config :content_type, :validate => :string, :default => "text/plain"

  public
  def register
    require "mail"

    @content_type_re = Regexp.new("^" + @content_type)
  end

  public
  def decode(payload, &block)
    mail = Mail.read_from_string(payload)
    
    if @strip_attachments
      mail = mail.without_attachments
    end

    event = LogStash::Event.new("raw" => payload, "parts" => mail.parts.count)

    # Use the 'Date' field as the timestamp
    event.timestamp = LogStash::Timestamp.new(mail.date.to_time)

    # Add fields: Add message.header_fields { |h| h.name=> h.value }
    mail.header_fields.each do |header|
      # 'header.name' can sometimes be a Mail::Multibyte::Chars, get it in String form
      name = @lowercase_headers ? header.name.to_s.downcase : header.name.to_s
      # Call .decoded on the header in case it's in encoded-word form.
      # Details at:
      #   https://github.com/mikel/mail/blob/master/README.md#encodings
      #   http://tools.ietf.org/html/rfc2047#section-2
      value = transcode_to_utf8(header.decoded.to_s)

      case (field = event.get(name))
      when String
        # promote string to array if a header appears multiple times
        # (like 'received')
        event.set(name, [field, value])
      when Array
        field << value
        event.set(name, field)
      when nil
        event.set(name, value)
      end
    end

    yield event
  end

  # transcode_to_utf8 is meant for headers transcoding.
  # the mail gem will set the correct encoding on header strings decoding
  # and we want to transcode it to utf8
  def transcode_to_utf8(s)
    unless s.nil?
      s.encode(Encoding::UTF_8, :invalid => :replace, :undef => :replace)
    end
  end
end
