FROM mcr.microsoft.com/dotnet/framework/sdk:4.8-windowsservercore-ltsc2019 AS build

ARG root_project="aspnetmvcapp"

WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY $root_project/*.csproj ./$root_project/
COPY $root_project/*.config ./$root_project/
RUN nuget restore

# copy everything else and build app
COPY $root_project/. ./$root_project/
WORKDIR /app/$root_project
RUN msbuild /p:Configuration=Release


FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019 AS runtime
WORKDIR /inetpub/wwwroot
COPY --from=build /app/$root_project/. ./
