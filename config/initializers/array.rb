class Array
  def delete_blank
    delete_if(&:blank?)
  end
end
