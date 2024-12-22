using DemoApi.Domain;
using Microsoft.EntityFrameworkCore;

namespace DemoApi.Infrastructure;

public class DatabaseContext(DbContextOptions<DatabaseContext> options) : DbContext(options)
{
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<Post> Posts { get; set; }
}

