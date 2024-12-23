using System.ComponentModel.DataAnnotations;

namespace DemoApi.Domain;

public class Blog
{
    [Key]
    public int BlogId { get; set; }
    public required string Url { get; set; }

    public List<Post> Posts { get; } = [];
}
