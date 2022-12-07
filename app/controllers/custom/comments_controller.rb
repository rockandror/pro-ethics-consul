require_dependency Rails.root.join("app", "controllers", "comments_controller").to_s

class CommentsController
  include GuestUsers

  skip_before_action :authenticate_user!
end
