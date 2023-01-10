require_dependency Rails.root.join("app", "controllers", "legislation", "draft_versions_controller").to_s

class Legislation::DraftVersionsController < Legislation::BaseController
  include GuestUsers
end
