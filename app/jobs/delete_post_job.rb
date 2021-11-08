class DeletePostJob < ApplicationJob
  queue_as :default

  def perform(id)
    Post.destroy(id)
  end
end
