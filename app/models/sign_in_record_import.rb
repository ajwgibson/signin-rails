class SignInRecordImport < ApplicationRecord

  has_attached_file :upload_file
  validates_attachment :upload_file, presence: true, content_type: { content_type: ["text/plain", "text/csv"] }

  has_attached_file :error_file
  validates_attachment_content_type :error_file, :content_type => ["text/plain", "text/csv"]


  enum status: [ :pending, :running, :complete ]

end
