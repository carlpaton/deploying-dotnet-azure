using DemoApi.Blogs;
using DemoApi.Infrastructure;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// POSTGRES -> Npgsql.EntityFrameworkCore.PostgreSQL 9.0.2
//builder.Services.AddDbContext<DatabaseContext>(o =>
//    o.UseNpgsql(connectionString));

//MSSQL -> Microsoft.EntityFrameworkCore.SqlServer 9.0.0
builder.Services.AddDbContext<DatabaseContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("SqlServer")));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<DatabaseContext>();
    context.Database.Migrate();
}

app.MapBlogEndpoints();
app.Run();