class Comparison
  include ActiveModel::Model
  attr_accessor :id, :range
  validates :id,
            presence: true,
            format: {
              with: /\A[\w_\-.]+\z/,
              message: 'only allows letters'
            }
  validates :range,
            presence: true,
            format: {
              with: /\A[\w_\-.\/]+\z/,
              message: 'only allows letters'
            }

  class RubygemsNotFound < StandardError; end
  class ComparisonNotFound < StandardError; end
  class InvalidParameters < StandardError; end

  def from
    result, _ = range.split('...')
    result
  end

  def to
    _, result = range.split('...')
    result
  end

  def build_url(name, version_from, version_to)
    "/v1/diffs?from=#{name}-#{version_from}&to=#{name}-#{version_to}"
  end

  def execute
    url = build_url(id, from, to)
    conn = ::Faraday.new(url: Rails.application.secrets.raw_api_server) do |faraday|
      faraday.request :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter ::Faraday.default_adapter  # make requests with Net::HTTP
    end

    response = conn.get url
    response.body
  end
end
