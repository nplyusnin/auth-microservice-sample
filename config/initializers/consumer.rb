channel = RabbitMq.consumer_channel
queue = channel.queue('auth', durable: true)
exchange = channel.default_exchange

queue.subscribe do |delivery_info, properties, payload|
  token = JSON.parse(payload)['token']
  user_uuid = JwtEncoder.decode(token)
  result = Auth::FetchUserService.call(user_uuid)

  if result.success?
    exchange.publish(
      result.user.id.to_s,
      routing_key: properties.reply_to,
      correlation_id: properties.correlation_id
    )
  end
end