using DemoApi.Domain;
using DemoApi.Infrastructure;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

var context = new DatabaseContext();

app.MapGet("/blogs", () =>
{
    var blogs = context.Blogs.ToList();
    return blogs;
})
.WithName("GetBlogs")
.WithOpenApi();

app.MapGet("/blogs/{id}", async (int id) =>
    await context.Blogs.FindAsync(id)
        is Blog blog
            ? Results.Ok(blog)
            : Results.NotFound())
.WithName("GetBlog")
.WithOpenApi();

app.MapPost("/blogs", async (Blog blog) =>
{
    context.Blogs.Add(blog);
    await context.SaveChangesAsync();

    return Results.Created($"/blogs/{blog.BlogId}", blog);
})
.WithName("CreateBlog")
.WithOpenApi();

app.Run();