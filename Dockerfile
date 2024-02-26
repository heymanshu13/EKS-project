FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

WORKDIR /app


COPY . ./


RUN dotnet restore "WebApplication1.csproj"


RUN dotnet build --configuration Release --no-restore


RUN dotnet publish --configuration Release --no-restore --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0


WORKDIR /app

# Copy the published files from the build image to the runtime image
COPY --from=build-env /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
