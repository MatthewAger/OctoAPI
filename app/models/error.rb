# frozen_string_literal: true

class Error
  CODES = {
    INVALID_PRODUCT_ID: {
      code: 'INVALID_PRODUCT_ID',
      message: 'The Product ID was invalid or missing'
    },
    UNPROCESSABLE_ENTITY: {
      code: 'UNPROCESSABLE_ENTITY',
      message: 'The request was well-formed but was unable to be followed due to semantic errors'
    }
  }.freeze
end
