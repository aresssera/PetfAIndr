FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["petfaindr/petfaindr.csproj", "petfaindr/"]
RUN dotnet restore "petfaindr/petfaindr.csproj"
COPY . .
WORKDIR "/src/petfaindr"
RUN dotnet build "petfaindr.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "petfaindr.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "petfaindr.dll"]
