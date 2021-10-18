FROM mcr.microsoft.com/dotnet/sdk:2.1-nanoserver-1809 AS builder

WORKDIR /app

COPY AlbumViewerNetCore.sln .
COPY src/AlbumViewerNetCore/AlbumViewerNetCore.csproj src/AlbumViewerNetCore/AlbumViewerNetCore.csproj
COPY src/AlbumViewerBusiness/AlbumViewerBusiness.csproj src/AlbumViewerBusiness/AlbumViewerBusiness.csproj
COPY src/Westwind.Utilities/Westwind.Utilities.csproj src/Westwind.Utilities/Westwind.Utilities.csproj

RUN dotnet restore src/AlbumViewerNetCore/AlbumViewerNetCore.csproj

COPY . .

RUN dotnet publish "AlbumViewerNetCore.sln"

FROM mcr.microsoft.com/dotnet/aspnet:2.1-nanoserver-1809 AS base

WORKDIR /app

COPY --from=builder /app/src/AlbumViewerNetCore/bin/Debug/netcoreapp2.0/publish/ .

ENTRYPOINT ["dotnet", "AlbumViewerNetCore.dll"]