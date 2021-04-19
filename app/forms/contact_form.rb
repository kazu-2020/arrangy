class ContactForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :category, :string
  attribute :body, :string

  validates :category, presence: true, inclusion: { in: %w[バグ、不具合について 機能追加の提案について その他の問い合わせ] }
  validates :body, presence: true, length: { maximum: 1_000 }

  def save!
    raise ActiveRecord::RecordInvalid unless valid?

    slack = Slack::Notifier.new(Rails.application.credentials.dig(:slack, :webhock), channel: '#お問い合わせ一覧')
    message = <<-MSG
      <!channel>
      お問い合わせ項目: #{category}
      お問い合わせ内容
      #{body}
    MSG
    slack.ping(message)
  end
end
