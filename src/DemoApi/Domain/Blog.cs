using Microsoft.Extensions.Hosting;

namespace DemoApi.Domain;

public class Blog
{
    public int BlogId { get; set; }
    public required string Url { get; set; }

    public List<Post> Posts { get; } = [];
}
