require 'singleton'

class QueryParamsManager
  include Singleton

  def self.query_params(auth_params)
    URI.escape(auth_params.collect{|k,v| "#{k}=#{v}"}.join('&'))
  end
end
