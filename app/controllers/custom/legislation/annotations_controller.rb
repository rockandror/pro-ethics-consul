require_dependency Rails.root.join("app", "controllers", "legislation", "annotations_controller").to_s

class Legislation::AnnotationsController
  include GuestUsers

  skip_before_action :authenticate_user!
end
