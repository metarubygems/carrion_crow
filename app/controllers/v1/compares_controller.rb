module V1
  class ComparesController < ApplicationController
    def show
      comparison = Comparison.new(compare_params)
      fail Comparison::InvalidParameters unless comparison.valid?
      render plain: comparison.execute
    end

    private

    def compare_params
      params.permit(:id, :range)
    end
  end
end
