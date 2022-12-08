# Setup sql server

sudo docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<YourStrong@Passw0rd>" \
    -e "MSSQL_PID=Express" \
    -p 1433:1433 --name sql1 --hostname sql1 \
    -d mcr.microsoft.com/mssql/server:2017-latest

username: SA
password: ?

Referencias:

- https://hub.docker.com/_/microsoft-mssql-server
- https://learn.microsoft.com/en-us/sql/linux/quickstart-install-connect-docker?view=sql-server-2017&preserve-view=true&pivots=cs1-bash
- https://abi.gitbook.io/net-core/introduccion/2.-instalacion-de-sql-server-en-mac