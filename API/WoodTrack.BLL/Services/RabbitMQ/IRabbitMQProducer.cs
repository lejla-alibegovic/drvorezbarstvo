namespace WoodTrack.BLL;
public interface IRabbitMQProducer
{
    public void SendMessage<T>(T message);
}

