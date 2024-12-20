using DemoApi.Domain;
using Microsoft.EntityFrameworkCore;

namespace DemoApi.Infrastructure;

public class DatabaseContext : DbContext
{
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<Post> Posts { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
        => options.UseNpgsql("Server=localhost;Port=5432;Database=demo_db;UserId=postgres;Password=42ebe52d-ddc9-47c6-b03d-b2cd1ca17393");
}

