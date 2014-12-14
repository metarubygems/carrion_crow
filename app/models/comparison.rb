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

  def execute

  end
end
