module CongregationDeviseHelper

  def resource_name
    :congregation
  end

  def resource
    @resource ||= Congregation.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:congregation]
  end

end