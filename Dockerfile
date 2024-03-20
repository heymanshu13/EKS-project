FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env

WORKDIR /app
COPY . ./

RUN dotnet restore "WebApplication1.sln"
RUN dotnet publish WebApplication1.csproj -c Release -o /app/bin/Publish

#RUN dotnet publish --configuration Release --no-restore --output /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/bin/Publish .
ENTRYPOINT ["dotnet", "WebApplication1.dll"]
