class GithubWebhooksController < ActionController::API
  include GithubWebhook::Processor

  # Handle push event
  def github_push(payload)
    # TODO: handle push webhook
  end

  # Handle create event
  def github_create(payload)
    # TODO: handle create webhook
  end

  private

  def webhook_secret(payload)
    ENV['GITHUB_WEBHOOK_SECRET']
  end

  def github_workflow_job(payload)
    puts __method__
    write_log(payload)
  end

  def github_workflow_run(payload)
    puts __method__
    write_log(payload)
  end

  def write_log(payload)
    File.open("messages.txt", "a") do |file|
      message = [
        "workflow_name: \t #{payload.dig(:workflow_job, :workflow_name)}",
        "action:        \t #{payload.dig(:action)}",
        "name:          \t #{payload.dig(:repository, :name)}",
        "login:         \t #{payload.dig(:sender, :login)}",
        "steps:         \t #{payload.dig(:workflow_job, :steps)}",
        "status:        \t #{payload.dig(:workflow_job, :status)}",
      ].join("\n")

      message = "\n#{message}\n"

      file.write(message)
      puts message
    end
  end
end
