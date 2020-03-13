module ApplicationHelper
  def alert_class_for(flash_type)
    {
      "success": "alert-success",
      "notice": "alert-info",
      "alert": "alert-warning",
      "error": "alert-danger"
    }.stringify_keys[flash_type.to_s] || flash_type.to_s
  end
end
