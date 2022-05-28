#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["src/MainProject.Template.Web.Public/MainProject.Template.Web.Public.csproj", "src/MainProject.Template.Web.Public/"]
COPY ["src/MainProject.Template.Web.Core/MainProject.Template.Web.Core.csproj", "src/MainProject.Template.Web.Core/"]
COPY ["src/MainProject.Template.Application/MainProject.Template.Application.csproj", "src/MainProject.Template.Application/"]
COPY ["src/MainProject.Template.Application.Shared/MainProject.Template.Application.Shared.csproj", "src/MainProject.Template.Application.Shared/"]
COPY ["src/MainProject.Template.Core.Shared/MainProject.Template.Core.Shared.csproj", "src/MainProject.Template.Core.Shared/"]
COPY ["src/MainProject.Template.Core/MainProject.Template.Core.csproj", "src/MainProject.Template.Core/"]
COPY ["src/MainProject.Template.EntityFrameworkCore/MainProject.Template.EntityFrameworkCore.csproj", "src/MainProject.Template.EntityFrameworkCore/"]
COPY ["src/MainProject.Template.GraphQL/MainProject.Template.GraphQL.csproj", "src/MainProject.Template.GraphQL/"]
RUN dotnet restore "src/MainProject.Template.Web.Public/MainProject.Template.Web.Public.csproj"
COPY . .
WORKDIR "/src/src/MainProject.Template.Web.Public"
RUN dotnet build "MainProject.Template.Web.Public.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MainProject.Template.Web.Public.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MainProject.Template.Web.Public.dll"]
