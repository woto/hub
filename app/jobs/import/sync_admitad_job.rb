class Import::SyncAdmitadJob < ApplicationJob
  queue_as :default

  def perform(*args)
    context = Networks::Admitad::Token::Restore.call
    context = Networks::Admitad::Token::Retrieve.call if context.failure?
    Networks::Admitad::Sync.call(context)
  end
end
