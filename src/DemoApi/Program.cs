using DemoApi.Domain;
using DemoApi.Infrastructure;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("SqlServer");

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// POSTGRES -> Npgsql.EntityFrameworkCore.PostgreSQL 9.0.2
//builder.Services.AddDbContext<DatabaseContext>(o =>
//    o.UseNpgsql(connectionString));

//MSSQL -> Microsoft.EntityFrameworkCore.SqlServer 9.0.0
builder.Services.AddDbContext<DatabaseContext>(options =>
    options.UseSqlServer(connectionString));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

// dirty hack, this would not be disposed but works for POC
var scope = app.Services.CreateScope();
var context = scope.ServiceProvider.GetRequiredService<DatabaseContext>();

// migrate the db when the app runs
//context.Database.Migrate();

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