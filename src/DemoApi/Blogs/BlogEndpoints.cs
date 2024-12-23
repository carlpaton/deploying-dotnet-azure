using DemoApi.Domain;
using DemoApi.Infrastructure;

namespace DemoApi.Blogs;

public static class BlogEndpoints
{
    public static void MapBlogEndpoints(this WebApplication app)
    {
        var group = app.MapGroup("blogs");

        group.MapGet("/", (DatabaseContext context) =>
        {
            var blogs = context.Blogs.ToList();
            return blogs;
        })
        .WithName("GetBlogs")
        .WithOpenApi();

        group.MapGet("/{id}", async (DatabaseContext context, int id) =>
            await context.Blogs.FindAsync(id)
                is Blog blog
                    ? Results.Ok(blog)
                    : Results.NotFound())
        .WithName("GetBlog")
        .WithOpenApi();

        group.MapPost("", async (DatabaseContext context, Blog blog) =>
        {
            context.Blogs.Add(blog);
            await context.SaveChangesAsync();

            return Results.Created($"/blogs/{blog.BlogId}", blog);
        })
        .WithName("CreateBlog")
        .WithOpenApi();
    }
}
